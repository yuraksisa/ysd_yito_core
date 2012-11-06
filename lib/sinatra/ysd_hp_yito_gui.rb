module Sinatra
  #
  # Sinatra Helpers to create User Interface
  #
  module YitoUIHelper

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
      
        action_button = <<-ACTION_BUTTON
          <button class="form-button element-action-button action-button entity-management-button" id="#{options[:id]}" title="#{options[:title]}">#{options[:text]}</button>
        ACTION_BUTTON
      
        if String.method_defined?(:encode)
          action_button.encode!('utf-8')
        end
        
        action_button
      
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
             $(window).load(function() {
                $("#{selector}").nivoSlider();
           	});
           });
         </script>
       SCRIPT
      
       return slider_js
    
     end     
      
  end
end