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

      attr_reader :context, :entity_aspects
      
      #
      # Constructor
      #
      # @param [Hash] context 
      #  The context
      #
      # @param [Array of Plugins::AspectConfiguration] the aspects to render 
      #  The aspects to render
      #
      def initialize(context, entity_aspects)
        @context = context
        @entity_aspects = entity_aspects.sort { |x, y| x.weight <=> y.weight }
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
         
         # templates are shown on element view
         element_template_above = ''
         element_template_above_ingroup = ''
         element_template_above_ingroup_tab = ''                       
         element_template = ''
         element_template_ingroup_tab = ''
         element_template_ingroup = ''
         element_extension = ''

         # Actions are shown on element view
         element_action = ''
         element_action_extension = ''
  
         # forms are show on element creation/edition
         edit_element_form_above = ''
         edit_element_form_above_ingroup_tab = ''
         edit_element_form_above_ingroup = ''
         edit_element_form = ''
         edit_element_form_ingroup_tab = ''
         edit_element_form_ingroup = ''
         edit_element_form_extension = ''

         new_element_form_above = ''
         new_element_form_above_ingroup_tab = ''
         new_element_form_above_ingroup = ''
         new_element_form = ''
         new_element_form_ingroup_tab = ''
         new_element_form_ingroup = ''
         new_element_form_extension = ''

         element_form_extension = ''
                             
         entity_aspects.each do |aspect_entity_configuration|
           
           aspect_gui = aspect_entity_configuration.get_aspect(context).gui_block

           if aspect_entity_configuration.show_on_edit

             if aspect_entity_configuration.weight < 0
               if aspect_gui.respond_to?(:element_form_tab) and aspect_entity_configuration.in_group
                 edit_element_form_above_ingroup_tab << aspect_gui.element_form_tab(context, aspect_model).force_encoding('utf-8') 
               end    
               if aspect_gui.respond_to?(:element_form)
                 if aspect_entity_configuration.in_group
                   edit_element_form_above_ingroup << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 else
                   edit_element_form_above << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 end
               end           	  
             else     
               if aspect_gui.respond_to?(:element_form_tab) and aspect_entity_configuration.in_group
                 edit_element_form_ingroup_tab << aspect_gui.element_form_tab(context, aspect_model).force_encoding('utf-8')
               end                                
               if aspect_gui.respond_to?(:element_form)
                 if aspect_entity_configuration.in_group
                   edit_element_form_ingroup << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 else
                   edit_element_form << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 end
               end
             end
        
             #if aspect_gui.respond_to?(:element_form_extension)
             #  edit_element_form_extension << aspect_gui.element_form_extension(context, aspect_model).force_encoding('utf-8')
             #end
          
          end      

          if aspect_entity_configuration.show_on_new

             if aspect_entity_configuration.weight < 0
               if aspect_gui.respond_to?(:element_form_tab) and aspect_entity_configuration.in_group
                 new_element_form_above_ingroup_tab << aspect_gui.element_form_tab(context, aspect_model).force_encoding('utf-8') 
               end    
               if aspect_gui.respond_to?(:element_form)
                 if aspect_entity_configuration.in_group
                   new_element_form_above_ingroup << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 else
                   new_element_form_above << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 end
               end              
             else     
               if aspect_gui.respond_to?(:element_form_tab) and aspect_entity_configuration.in_group
                 new_element_form_ingroup_tab << aspect_gui.element_form_tab(context, aspect_model).force_encoding('utf-8')
               end                                
               if aspect_gui.respond_to?(:element_form)
                 if aspect_entity_configuration.in_group
                   new_element_form_ingroup << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 else
                   new_element_form << aspect_gui.element_form(context, aspect_model).force_encoding('utf-8')
                 end
               end
             end
        
             #if aspect_gui.respond_to?(:element_form_extension)
             #  new_element_form_extension << aspect_gui.element_form_extension(context, aspect_model).force_encoding('utf-8')
             #end
          
          end 

          if aspect_gui.respond_to?(:element_form_extension)
            element_form_extension << aspect_gui.element_form_extension(context, aspect_model).force_encoding('utf-8')
          end

          if aspect_gui.respond_to?(:element_action)
            element_action << aspect_gui.element_action(context, aspect_model).force_encoding('utf-8')
          end

          if aspect_gui.respond_to?(:element_action_extension)
            element_action_extension << aspect_gui.element_action_extension(context, aspect_model).force_encoding('utf-8')
          end      
                                                        
         end

         element_template_above.force_encoding('utf-8') 
         element_template_above_ingroup_tab.force_encoding('utf-8')
         element_template_above_ingroup.force_encoding('utf-8')      
         element_template.force_encoding('utf-8')
         element_template_ingroup_tab.force_encoding('utf-8')
         element_template_ingroup.force_encoding('utf-8')
         element_extension.force_encoding('utf-8')
         
         element_action.force_encoding('utf-8')
         unless element_action.empty?
           element_action = build_action_menu(element_action)
         end

         element_action_extension.force_encoding('utf-8')

         edit_element_form_above.force_encoding('utf-8')
         edit_element_form_above_ingroup_tab.force_encoding('utf-8')
         edit_element_form_above_ingroup.force_encoding('utf-8')
         edit_element_form.force_encoding('utf-8')
         edit_element_form_ingroup_tab.force_encoding('utf-8')
         edit_element_form_ingroup.force_encoding('utf-8')
         edit_element_form_extension.force_encoding('utf-8')
         new_element_form_above.force_encoding('utf-8')
         new_element_form_above_ingroup_tab.force_encoding('utf-8')
         new_element_form_above_ingroup.force_encoding('utf-8')
         new_element_form.force_encoding('utf-8')
         new_element_form_ingroup_tab.force_encoding('utf-8')
         new_element_form_ingroup.force_encoding('utf-8')
         new_element_form_extension.force_encoding('utf-8')
         element_form_extension.force_encoding('utf-8')
               
         result = {:element_template_above => element_template_above,
                   :element_template_above_ingroup_tab => element_template_above_ingroup_tab,
         	         :element_template_above_ingroup => element_template_above_ingroup,
         	         :element_template => element_template,
                   :element_template_ingroup_tab => element_template_ingroup_tab,
                   :element_template_ingroup => element_template_ingroup,
                   :element_extension => element_extension,
                   :element_action => element_action,
                   :element_action_extension => element_action_extension,

                   :edit_element_form_above => edit_element_form_above,
                   :edit_element_form_above_ingroup_tab => edit_element_form_above_ingroup_tab,
                   :edit_element_form_above_ingroup => edit_element_form_above_ingroup,
                   :edit_element_form => edit_element_form,
                   :edit_element_form_ingroup_tab => edit_element_form_ingroup_tab,
                   :edit_element_form_ingroup => edit_element_form_ingroup,
                   :edit_element_form_extension => edit_element_form_extension,

                   :new_element_form_above => new_element_form_above,
                   :new_element_form_above_ingroup_tab => new_element_form_above_ingroup_tab,
                   :new_element_form_above_ingroup => new_element_form_above_ingroup,
                   :new_element_form => new_element_form,
                   :new_element_form_ingroup_tab => new_element_form_ingroup_tab,
                   :new_element_form_ingroup => new_element_form_ingroup,
                   :new_element_form_extension => new_element_form_extension,

                   :element_form_extension => element_form_extension

                 }           
           
         return result
          
      end

      private

      #
      # Build the element action menu from the options
      #
      def build_action_menu(element_action)

        app = context[:app]

        menu = []
        menu << "<ul"
        menu << "class=\"menu element_action_menu\">"
        menu << "<li class=\"menuitem\">"
        menu << "<a><img style=\"width:16px;padding-right: 4px;vertical-align: middle;position: relative;top: -2px;\" src=\"/assets/img/icomoon/
cog.png\">#{app.t.entitymanagement.complements}</a>"
        menu << "<ul class=\"submenu submenu-level1 element_action_submenu\">"
        menu << element_action
        menu << "</ul>"
        menu << "</li>"
        menu << "</ul>"
        
        menu = menu.join(" ")

        if String.method_defined?(:encode)
          menu.encode!('utf-8')
        end

        return menu

      end

  end
end