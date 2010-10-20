module FileAttachmentsHelper

  def description_display(file_attachment)
    content_tag :p, :id => "file_attachment_#{file_attachment.id}_description", :style => "max-width: 70%; float: right;" do
      file_attachment.description
    end
  end

end
