module UI
  #
  # Renders an aspect for an entity instance
  #
  #   - custom
  #   - custom_extension
  #
  #   - custom_action
  #   - custom_action_extension
  #
  #	
  class EntityAspectRender

      attr_reader :context, :aspects
      
      #
      # Constructor
      #
      # @param [Hash] context
      # @param [Array] the aspects to render
      #
      def initialize(context, aspects)
        @context = context
        @aspects = aspects
      end

      #
      # Render aspects complement
      #
      # @param [Object] element
      #  the element to render
      #
      # @param [Object] aspect model
      #  the entity to which the aspect is applied
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
      def render(element, aspect_model)
        
        element_custom_above = ''
        element_custom = ''
        element_custom_extensions = ''
        element_actions = ''
        element_actions_extensions = ''
      
        aspects.each do |aspect_entity|

          aspect = aspect_entity.get_aspect_definition(context)	
          
          if aspect_entity.weight < 0
            if aspect.respond_to?(:custom)
              element_custom_above << aspect.custom(context, element, aspect_model).force_encoding('utf-8')
            end
          else	
            if aspect.respond_to?(:custom)
              element_custom << aspect.custom(context, element, aspect_model).force_encoding('utf-8')
            end
          end

          if aspect.respond_to?(:custom_extension)
            element_custom_extensions << aspect.custom_extension(context, element, aspect_model).force_encoding('utf-8')
          end
          
          if aspect.respond_to?(:custom_action)
            element_actions << aspect.custom_action(context, element, aspect_model).force_encoding('utf-8')
          end
          
          if aspect.respond_to?(:custom_action_extension)
            element_actions_extensions << aspect.custom_action_extension(context, element, aspect_model).force_encoding('utf-8')
          end
        
        end
       
        element_custom_above.force_encoding('utf-8')
        element_custom.force_encoding('utf-8')
        element_custom_extensions.force_encoding('utf-8')
        element_actions.force_encoding('utf-8')
        element_actions_extensions.force_encoding('utf-8')
      
        {:element_actions => element_actions,
         :element_actions_extensions => element_actions_extensions,
         :element_custom_above => element_custom_above,
         :element_custom => element_custom,
         :element_custom_extensions => element_custom_extensions}     
      
      end


  end
end