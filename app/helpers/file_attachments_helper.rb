module FileAttachmentsHelper

  def description_display(file_attachment)
    content_tag :p, {
      :id => "file_attachment_#{file_attachment.id}_description",
      :style => "max-width: 70%; float: right;",
      :class => 'file_attachment_description'
    } do
      file_attachment.description
    end
  end
  
  def name_display(file_attachment)
    content_tag :p, {
      :id => "file_attachment_#{file_attachment.id}_name",
      :class => 'file_attachment_name'
    } do
      link_to(file_attachment.name, download_file_attachment_path(file_attachment.id))
    end
  end

end
