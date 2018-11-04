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
                                                      {:value => '/admin', :description => 'staff backend front page', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.name'},
                                                      {:value => '.', :description => 'Site company name', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.document_id'},
                                                      {:value => '.', :description => 'Site company document id', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.phone_number'},
                                                      {:value => '.', :description => 'Site company phone number', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.email'},
                                                      {:value => '.', :description => 'Site company email', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.address_1'},
                                                      {:value => '.', :description => 'Site company address 1', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.address_2'},
                                                      {:value => '.', :description => 'Site company address 2', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.city'},
                                                      {:value => '.', :description => 'Site company city', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.state'},
                                                      {:value => '.', :description => 'Site company state', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.zip'},
                                                      {:value => '.', :description => 'Site company zip', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.country'},
                                                      {:value => '.', :description => 'Site company country', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.facebook'},
                                                      {:value => '.', :description => 'Site company facebook', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.twitter'},
                                                      {:value => '.', :description => 'Site company twitter', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.instagram'},
                                                      {:value => '.', :description => 'Site company instagram', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.company.linkedin'},
                                                      {:value => '.', :description => 'Site company linkedin', :module => :yito_core})

        SystemConfiguration::Variable.first_or_create({:name => 'site.user_front_page'},
                                                      {:value => '/profile', :description => 'user front page', :module => :yito_core})

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

    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})    
      routes = [{:path => '/admin',
                 :regular_expression => /^\/admin$/, 
                 :title => 'Panel de administración' , 
                 :description => 'Inicio',
                 :fit => 1,
                 :module => :cms},                 
                ]
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

    #
    # Ignore the following path prefix in breadcrumb
    #
    def ignore_path_prefix_breadcrumb(context={})
      %w(/render)
    end

  end
end
