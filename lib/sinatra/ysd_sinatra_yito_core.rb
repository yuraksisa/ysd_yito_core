#
# Routes
#
module Sinatra
  module YSD
    module YitoCore
    
      def self.registered(app)
     
        # Add the local folders to the views and translations     
        app.settings.views = Array(app.settings.views).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'views')))
        app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'i18n')))       
                                       
       end
       
     end # YitoJS
  end #YSD
end # Sinatra