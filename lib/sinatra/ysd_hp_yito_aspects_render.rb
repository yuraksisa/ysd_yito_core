require 'ui/ysd_ui_entity_aspect_render'
require 'ui/ysd_ui_entity_management_aspect_render'

module Sinatra
  #
  # Sinatra Helpers to render entity management aspects
  #
  module YitoAspectsRenderHelper
    
    #
    # Renders the Aspects of an entity (in management)
    #
    # @param [String] model
    #
    #   The target name of the model
    #  
    def render_entity_management_aspects(model)

        context = {:app => self}
        result = {}
        
        if model = (Plugins::ModelAspect.registered_models.select { |m| m.target_model.to_sym == model.to_sym }).first
          aspects_render=UI::EntityManagementAspectRender.new(context, model.aspects) 
          result = aspects_render.render(model)
        end            
             
        return result
          
    end
    
    #
    # Render the aspects of an entity (in render)
    # @param [Object] element to render
    # @param [String] model
    #    The target name of the model
    #
    def render_entity_aspects(element, model)

        context = {:app => self}
        result = {}
        
        if model = (Plugins::ModelAspect.registered_models.select { |m| m.target_model.to_sym == model.to_sym }).first
          aspects_render=UI::EntityAspectRender.new(context, model.aspects) 
          result = aspects_render.render(element, model)
        end            
             
        return result
      
    end

  end #AspectsRenderHelper
end #Sinatra