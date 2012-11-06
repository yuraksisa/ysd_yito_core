module UI
  #
  # Renders the aspects for a entity management
  # 
  # The aspect delegates can be integrated in the system if the declare the following methods:
  # 
  #    - element_template_tab
  #    - element_template
  #    - element_extension
  #
  #    - element_action
  #    - element_action_extension
  #    
  #    - element_form_tab
  #    - element_form
  #    - element_form_extension
  #
  class EntityManagementAspectRender

      attr_reader :context, :aspects
      
      #
      # Constructor
      #
      def initialize(context, aspects)
        @context = context
        @aspects = aspects
      end     
      

      #
      # Render aspects complement for entity management framework
      # 
      # @param [Object] aspect model
      #  the model to which the aspect is applied
      #
      #  It can be any Object which implements the following method to retrieve the AspectConfiguration
      #
      #    def aspect(aspect_id)
      #
      #    end   
      #
      # @return [Hash]
      #  the aspects renders
      #
      def render(aspect_model)
         
         element_template_above = ''
         element_template_above_tab = ''                       
         element_template_tab = ''
         element_template = ''
         element_action = ''
         element_form_above_tab = ''
         element_form_above = ''
         element_form_tab = ''
         element_form = ''
         element_form_extension = ''
         element_extension = ''
         element_action_extension = ''
                    
         aspects.each do |aspect_entity|
           
           aspect = aspect_entity.get_aspect_definition(context)

           if aspect_entity.weight < 0
             if aspect.respond_to?(:element_template_tab)
               element_template_above_tab << aspect.element_template_tab(context, aspect_model).force_encoding('utf-8')
             end
             if aspect.respond_to?(:element_template)
               element_template_above << aspect.element_template(context, aspect_model).force_encoding('utf-8')
             end                      
           else
             if aspect.respond_to?(:element_template_tab)
               element_template_tab << aspect.element_template_tab(context, aspect_model).force_encoding('utf-8')
             end
             if aspect.respond_to?(:element_template)
               element_template << aspect.element_template(context, aspect_model).force_encoding('utf-8')
             end           
           end

           if aspect.respond_to?(:element_action)
             element_action << aspect.element_action(context, aspect_model).force_encoding('utf-8')
           end
           
           if aspect_entity.weight < 0
             if aspect.respond_to?(:element_form_tab)
               element_form_above_tab << aspect.element_form_tab(context, aspect_model).force_encoding('utf-8')
             end    
             if aspect.respond_to?(:element_form)
               element_form_above << aspect.element_form(context, aspect_model).force_encoding('utf-8')
             end           	  
           else     
             if aspect.respond_to?(:element_form_tab)
               element_form_tab << aspect.element_form_tab(context, aspect_model).force_encoding('utf-8')
             end                                
             if aspect.respond_to?(:element_form)
               element_form << aspect.element_form(context, aspect_model).force_encoding('utf-8')
             end
           end
        
           if aspect.respond_to?(:element_form_extension)
             element_form_extension << aspect.element_form_extension(context, aspect_model).force_encoding('utf-8')
           end
                
           if aspect.respond_to?(:element_extension)
             element_extension << aspect.element_extension(context, aspect_model).force_encoding('utf-8')
           end
                
           if aspect.respond_to?(:element_action_extension)
             element_action_extension << aspect.element_action_extension(context, aspect_model).force_encoding('utf-8')
           end
                                                        
         end

         element_template_above_tab.force_encoding('utf-8')
         element_template_above.force_encoding('utf-8')      
         element_template_tab.force_encoding('utf-8')
         element_template.force_encoding('utf-8')
         element_action.force_encoding('utf-8')
         element_form_above_tab.force_encoding('utf-8')
         element_form_above.force_encoding('utf-8')
         element_form_tab.force_encoding('utf-8')
         element_form.force_encoding('utf-8')
         element_form_extension.force_encoding('utf-8')
         element_extension.force_encoding('utf-8')
         element_action_extension.force_encoding('utf-8')
      
         result = {:element_template_above_tab => element_template_above_tab,
         	       :element_template_above => element_template_above,
         	       :element_template_tab => element_template_tab,
                   :element_template => element_template,
                   :element_action => element_action,
                   :element_form_above_tab => element_form_above_tab,
                   :element_form_above => element_form_above,
                   :element_form_tab => element_form_tab,
                   :element_form => element_form,
                   :element_form_extension => element_form_extension,
                   :element_extension => element_extension,
                   :element_action_extension => element_action_extension}           
           
         return result
          
      end

  end
end