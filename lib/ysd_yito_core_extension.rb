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
            

        SystemConfiguration::Variable.first_or_create({:name => 'site.cache.enabled'},
                                                      {:value => 'false', :description => 'page cache enabled', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.cache.page_life'},
                                                      {:value => '180', :description => 'page cache life in seconds', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.extra_styles'},
                                                       {:value => '', :description => 'Extra links href separated by comma', :module => :yito_core})   

        SystemConfiguration::Variable.first_or_create({:name => 'site.extra_scripts'},
                                                       {:value => '', :description => 'Extra scripts sources separated by comma', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.title'},
                                                       {:value => 'Yito Site', :description => 'site title', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.slogan'},
                                                       {:value => '', :description => 'site subtitle', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.logo'},
                                                       {:value => '', :description => 'site logo', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.theme'},
                                                       {:value => 'default', :description => 'site theme', :module => :yito_core})   

        SystemConfiguration::Variable.first_or_create({:name => 'site.template_engine'},
                                                       {:value => 'erb', :description => 'default engine', :module => :yito_core})   

        SystemConfiguration::Variable.first_or_create({:name => 'site.domain'},
                                                       {:value => '', :description => 'site domain', :module => :yito_core})   

        SystemConfiguration::Variable.first_or_create({:name => 'site.front_page'},
                                                      {:value => '/admin', :description => 'backend front page', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.user_front_page'},
                                                      {:name => '/', :description => 'regular user admin area', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.anonymous_front_page'},
                                                      {:value => '/', :description => 'public front page', :module => :yito_core})


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

    #
    # ---------- Path prefixes to be ignored ----------
    #

    #
    # Ignore the following path prefixes in language processor
    #
    def ignore_path_prefix_language(context={})
      %w(/dashboard /admin /api /render)
    end

    #
    # Ignore the following path prefix in cms
    #
    def ignore_path_prefix_cms(context={})
      %w(/dashboard /admin /api /render)
    end

  end
end