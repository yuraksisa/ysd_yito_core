module Sinatra
  #
  # Sinatra Helpers to render entity management aspects
  #
  module YitoAspectsRenderHelper
    
    #
    # Renders the Aspects of an entity
    #
    # @param [String] model
    #
    #   The target name of the model
    #  
    def render_entity_aspects(model)

        context = {:app => self}
        result = {}
        
        if model = (Plugins::ModelAspect.registered_models.select { |m| m.target_model == model }).first
          aspects_render=UI::EntityManagementAspectRender.new(context, model.aspects) 
          aspects_render.render(model)
        end            
             
        return result
          
    end

  end #AspectsRenderHelper
end #Sinatra