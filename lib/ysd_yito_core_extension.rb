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
  end
end