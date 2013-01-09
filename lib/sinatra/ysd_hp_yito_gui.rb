module Sinatra
  #
  # Sinatra Helpers to create User Interface
  #
  module YitoUIHelper

     #
     # It Renders a tab
     #
     def render_tab(id, description)
       tab = <<-TAB
         <li><a href="##{id}">#{description}</a></li>
       TAB
     end
     
     #
     # Renders an action menu item
     #
     # @params [Hash] options
     # 
     #  :text The anchor text
     #  :id   The list item id
     #
     def render_element_action_menuitem(options)

       menu_item = []
       menu_item << "<li"
       menu_item << "id=\"#{options[:id]}\""
       menu_item << "class=\"menuitem element_action_submenu\""
       menu_item << ">"
       menu_item << "<a>#{options[:text]}</a>"
       menu_item << "</li>"

       menu_item = menu_item.join(" ")

       if String.method_defined?(:encode)
         menu_item.encode!('utf-8')
       end

       return menu_item

     end

     #
     # Renders an action button 
     #
     # @param [Hash] options
     #
     #  :text  The button text
     #  :title The button title
     #  :id    The button id
     # 
     def render_element_action_button(options)
      
        action_button = []
        action_button << "<button"
        action_button << "class=\"form-button element-action-button action-button entity-management-button #{options.fetch(:class,'')}\""
        action_button << "id=\"#{options[:id]}\""
        action_button << "title=\"#{options[:title]}\""
        action_button << "data-action-method=\"#{options[:action_method]}\"" if options.has_key?(:action_method)
        action_button << "data-action-url=\"#{options[:action_url]}\"" if options.has_key?(:action_url)
        action_button << "data-confirm-message=\"#{options[:confirm_message]}\"" if options.has_key?(:confirm_message)
        action_button << ">#{options[:text]}</button>"

        button = action_button.join(" ")

        if String.method_defined?(:encode)
          button.encode!('utf-8')
        end
        
        return button
      
     end
     
     #
     # Renders an image
     # 
     # @params [Hash] options
     #
     #  :src
     #  :alt
     #  :title
     #  :class_name
     #  :width
     #  :height
     #
     def img(options)
       
       src = options[:src]
       alt = options[:alt]
       title = options[:title]
       class_name = options[:class_name]
       width = options[:width]
       height = options[:height]
       
       # TODO check the url alias (to CDN ...)
       
       image_array = ["<img src=\"#{src}\""]
       
       if alt
         image_array << "alt=\"#{alt}\""
       end

       if title
         image_array << "title=\"#{title}\""
       end
              
       if class_name
         image_array << "class_name=\"#{class_name}\""
       end
       
       style = ''
       
       if width
         style << "width: #{width}"
       end
       
       if height
         style << ";" if style.strip.length > 0 
         style << "height: #{height}"
       end 
       
       if style.strip.length > 0
         image_array << "style=\"#{style}\""
       end
       
       image_array << "/>"
       
       return image_array.join(' ')
       
     end
      
     #
     # Renders an slider
     #
     def slider(selector)
    
       slider_js = <<-SCRIPT
         <script type="text/javascript">
           require(['jquery', 'jquery.nivo.slider'], function($) {
//             $(window).load(function() {
                $("#{selector}").nivoSlider();
//           	});
           });
         </script>
       SCRIPT
      
       return slider_js
    
     end     
      
  end
end