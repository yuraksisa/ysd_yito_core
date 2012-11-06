require 'ysd-plugins' unless defined?Plugins::Plugin

Plugins::SinatraAppPlugin.register :yito_core do

   name=        'yito_core'
   author=      'yurak sisa'
   description= 'yito base'
   version=     '0.1'
   sinatra_extension Sinatra::YSD::YitoCore
   sinatra_helper Sinatra::YitoPageBuilderHelper
   sinatra_helper Sinatra::YitoUIHelper
   sinatra_helper Sinatra::YitoEntityManagementHelper
   sinatra_helper Sinatra::YitoAspectsRenderHelper
   sinatra_helper Sinatra::YitoResourcesLoaderHelper
   
end

