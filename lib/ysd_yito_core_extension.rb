#
# Huasi CMS Extension
#
module Huasi

  class YitoCoreExtension < Plugins::ViewListener

    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})
            
        SystemConfiguration::Variable.first_or_create({:name => 'site.title'},
                                                       {:value => 'Yito Site', :description => 'site title', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.slogan'},
                                                       {:value => '', :description => 'site subtitle', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.logo'},
                                                       {:value => '', :description => 'site logo', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.theme'},
                                                       {:value => 'default', :description => 'site theme', :module => :cms})   

        SystemConfiguration::Variable.first_or_create({:name => 'site.template_engine'},
                                                       {:value => 'erb', :description => 'default engine', :module => :yito_core})   

    end


    # --------- Menus --------------------

    #
    # It defines the apps menu 
    #
    # @return [Array]
    #  Menu definition
    #
    def menu(context={})
      
      app = context[:app]
      
      menu_items = [{:path => '/apps',
                     :options => {
                        :title => app.t.system_admin_menu.apps_menu,
                        :description => 'Apps',
                        :module => :yito,
                        :weight => 0}
                     }]
                    
    end

  end
end