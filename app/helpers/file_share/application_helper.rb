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

      unless wrapper_options.delete(:no_wrapper)
        return content_tag(tag, wrapper_options) do
          link_to(link_text, path, link_options)
        end
      else
        return link_to(link_text, path, link_options)
      end
    end
  
    def link_to_file_attachments(wrapper_options={})
      link_wrapper(file_attachments_path, wrapper_options, {
        :link_text => 'List / Upload Files'
      })
    end
    
    def render_file_share_main_menu
      render :partial => 'file-share-shared/main_menu'
    end
    
    def render_file_share_navigation
      render :partial => 'file-share-shared/navigation'
    end
    
    def file_share_stylesheet_includes
      [
        "formtastic",
        "formtastic_changes",
        "error_messages",
        "text_and_colors",
        "application"
      ]
    end
    def file_share_javascript_includes
      list = [
        "jquery-ui-1.7.2.custom.min.js",
        "jquery.tablesorter.min.js",
        "jquery.string.1.0-min.js",
        "jquery.clonePosition.js",
        "lowpro.jquery.js",
        "jquery.qtip-1.0.0-rc3.js",
        "rails.js",
        "behaviors.js",
        "application.js"
      ]
      unless Rails.env == 'production'
        list.unshift("jquery-1.4.2.min.js")
      else
        list.unshift("http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js")
      end
      list
    end
  end
end
