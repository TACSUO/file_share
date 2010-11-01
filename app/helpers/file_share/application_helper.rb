module FileShare
  module ApplicationHelper
    def link_wrapper(path, wrapper_options={}, link_options={})
      tag       = wrapper_options.delete(:tag) || :p
      link_text = link_options.delete(:link_text) || path
      highlight = wrapper_options.delete(:highlight)

      unless path.blank?
        if current_page?(path) && (highlight.nil? || highlight)
          wrapper_options = {:class => (wrapper_options[:class] || '') + " nav_highlight"}
        end
      end

      content_tag(tag, wrapper_options) do
        link_to(link_text, path, link_options)
      end
    end
  
    def link_to_file_attachments
      link_wrapper(file_attachments_path, {}, {
        :link_text => 'List / Upload Files'
      })
    end
  end
end
