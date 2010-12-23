# t.string   "name"
# t.text     "description"
# t.string   "filepath"
# t.integer  "event_id"
# t.datetime "created_at"
# t.datetime "updated_at"

class FileAttachment < ActiveRecord::Base
  set_table_name "file_share_file_attachments"
  
  FOLDER = 'files'
  FOLDER_ROOT = File.join(Rails.root.to_s, 'public')
  FOLDER_PATH = File.join(FOLDER_ROOT, FOLDER)
  TRASH_FOLDER = File.join(FOLDER_PATH, 'trash')
  
  validates_presence_of :name, :filepath
  
  belongs_to :attachable, :polymorphic => true
  
  before_validation :autofill_blank_name, :on => :create
  before_validation :save_to_folder_path, :on => :create
  before_save :normalize_attachable_fields
  before_destroy :move_file_to_trash_folder!

  attr_accessor :uploaded_file
  
  scope :orphans, where('attachable_id IS NULL')
  scope :attached, where('attachable_id IS NOT NULL')
  
  private
    def normalize_attachable_fields
      if attachable_type.blank? || attachable_id.blank?
        self.attachable_type = nil
        self.attachable_id = nil
      end
    end
    def move_file_to_trash_folder!
      ensure_folder_path_exists(TRASH_FOLDER)
      trash_filename = generate_unique_filename(TRASH_FOLDER)
      
      FileUtils.mv(full_path, File.join(TRASH_FOLDER, trash_filename))
      
      unless File.exists?(File.join(TRASH_FOLDER, trash_filename))
        raise Errno::ENOENT("The file at #{File.join(FOLDER_ROOT, filepath)} should be in the trash at #{File.join(TRASH_FOLDER, trash_filename)}")
      end
      logger.info("Moved File Attachment to Trash: #{File.join(TRASH_FOLDER, trash_filename)}")
    end
    def save_to_folder_path
      ensure_folder_path_exists
      build_filepath
      File.open(full_path, "wb") { |f| f.write(uploaded_file.read) }
      return true if file_saved?
      errors.add_to_base("The file could not be saved. Please try again or contact someone and make a note of how many files, what kind, etc.")
      false
    end
    def generate_unique_filename(dest_path=FOLDER_PATH)
      base_filename = File.basename(uploaded_file && uploaded_file.original_filename || filepath)
      new_filename = base_filename
      path = File.join dest_path, new_filename
      count = 0
      until !File.exists? path
        count += 1
        new_filename = base_filename.gsub File.extname(base_filename), "-#{count}#{File.extname(base_filename)}"
        path = File.join dest_path, new_filename
      end
      new_filename
    end
    def ensure_folder_path_exists(dest_path=FOLDER_PATH)
      FileUtils.mkdir_p dest_path
    end
    def build_filepath
      self.filepath = File.join FOLDER, generate_unique_filename
    end
    def autofill_blank_name
      if name.blank?
        self.name = self.uploaded_file.original_filename
      end
    end
  protected
  public
    def full_path
      "#{FOLDER_ROOT}/#{filepath}"
    end
    def file_saved?
      return true if File.exists?(full_path) && File.basename(full_path) != FOLDER
      return false
    end
    def file_container
      return nil unless attachable_type.present? && attachable_id.present?
      "#{attachable_type}_#{attachable_id}"
    end
    def file_container=(container)
      p = container.split("_")
      self.attachable_type = p[0].blank? ? nil : p[0]
      self.attachable_id = p[1].blank? ? nil : p[1]
    end
end
