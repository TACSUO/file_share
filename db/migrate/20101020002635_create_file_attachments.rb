class CreateFileAttachments < ActiveRecord::Migration
  def self.up
    create_table :file_attachments do |t|
      t.string :name
      t.text :description
      t.string :filepath
      t.integer :attachable_id
      t.string :attachable_type

      t.timestamps
    end
    
    add_index :file_attachments, :attachable_id
  end

  def self.down
    drop_table :file_attachments
  end
end
