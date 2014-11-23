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
                $("#{selector}").nivoSlider({
                  animspeed: 2000,
                  pauseTime: 10000
                  });
//           	});
           });
         </script>
       SCRIPT
      
       return slider_js
    
     end     

     #
     # Render an input text 
     #
     # @param [String] value
     # @param [String] variable name
     # @param [String] label
     # @param [Number] maxlength
     # @param [Number] size
     # @param [String] class name
     #
     def render_input_text(value, variable_name, label, maxlength, size, class_name='')

         editor = <<-EDITOR 
              <div style="style="display:inline-block">
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol #{class_name}" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}" data-autosubmit="true"/>
              </div>
         EDITOR

     end    

     #
     # Render a textarea 
     #
     # @param [String] Value
     # @param [String] Variable name
     # @param [String] The label
     # @param [String] class name      
     #
     def render_textarea(value, variable_name, label, class_name='')

         editor = <<-EDITOR 
              <div style="style="display:inline-block;">
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol #{class_name}" rows="5" data-autosubmit="true">#{value}</textarea>
              </div>
         EDITOR

     end

     #
     # Render an input text with autosubmit
     #
     # @param [String] variable name
     # @param [String] label
     # @param [Number] maxlength
     # @param [Number] size
     # @param [String] class name
     #
     def render_input_text_autosubmit(action, value, variable_name, label, maxlength, size, class_name='')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="#{action}" method="POST" 
                 data-remote="ajax" data-remote-method="PUT" style="display:inline-block">
              <div style="style="display:inline-block">
                <input type="text" name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol #{class_name}" maxlength="#{maxlength}" size="#{size}" 
                value="#{value}" data-autosubmit="true"/>
              </div>
           </form>
         EDITOR

     end    

     #
     # Render a textarea with autosubmit
     #
     # @param [String] The configuration variable name
     # @param [String] The label
     # @param [String] class name      
     #
     def render_textarea_autosubmit(action, value, variable_name, label, class_name='')

         editor = <<-EDITOR 
           <form name="#{variable_name}" action="#{action}" method="PUT" 
                 data-remote="ajax" data-remote-method="PUT" style="display:inline-block">
              <div style="style="display:inline-block;">
                <textarea name="#{variable_name}" id="#{variable_name}" 
                class="fieldcontrol #{class_name}" rows="5" data-autosubmit="true">#{value}</textarea>
              </div>
           </form>
         EDITOR

     end
      
  end
end