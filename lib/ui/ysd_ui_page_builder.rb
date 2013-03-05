require 'ysd-plugins' if not defined?Plugins
require 'ysd_core_themes' unless defined?Themes
require 'ysd_ui_entity_aspect_render' unless defined?UI::EntityAspectRender

module UI

  #
  # It's the responsible of generating a site page
  #
  # Usage:
  #
  #  UI::PageBuilder.build(page, context)
  #
  #
  class PageBuilder

    #
    # Builds a page from it content and the context
    #
    # @param [UI::Page] page
    #
    # @param [Object] context
    #
    def self.build(page, context, options={})
        
      # Creates an instance of the page
      page_builder = PageBuilder.new(Themes::ThemeManager.instance.selected_theme.regions)
    
      # Builds the page
      page_builder.build_page(page, context, options)
              
    end

    # ---------------------------------------------

    #
    # Constructor
    # 
    # @param [Array] regions
    #
    #   The page regions (retrieved from the theme)
    #
    def initialize(regions)
    
      @variables = {}
    
      # Define the regions which will hold the contents    
      regions.each do |region|
        @variables.store(region.to_sym, []) 
      end
    
    end
 
    # Builds a page
    #
    # @param [Object] page
    #   The page to render
    #
    # @param [Object] context
    #   The context in which the render will be done
    #
    # @param [Hash] options
    #   Render options
    #
    def build_page(page, context, options={})
      
      app = context[:app]
      locals = options[:locals] || {} 
      layout = if options.has_key?(:layout)
                 if options[:layout]
                   options[:layout]
                 else
                   'blank'
                 end
               else 
                 'page_render'
               end
      
      locals.merge!(page_configuration)

      page.styles    ||= ''
      page.scripts   ||= ''
      page.variables ||= {}

      page.styles  << get_styles(context)
      page.scripts << get_scripts(context)
      page.variables.merge!(pre_processors(context))

      # Renders the page
      page_template_path = find_template(context, layout)
      page_template = Tilt.new(page_template_path) 
      page_render = page_template.render(app, locals.merge({:page => page}))          
                 
    end
    
    private
    
    #
    # Get the page configuration
    #
    def page_configuration

      page_locals = {}
      page_locals.store(:site_title, SystemConfiguration::Variable.get_value('site.title'))
      page_locals.store(:site_slogan, SystemConfiguration::Variable.get_value('site.slogan'))
      page_locals.store(:site_logo, SystemConfiguration::Variable.get_value('site.logo'))

      return page_locals

    end

    #
    # Get the styles
    #
    def get_styles(context)
      
      styles = []    
      styles.concat(Plugins::Plugin.plugin_invoke_all('page_style', context))
      styles.concat(Themes::ThemeManager.instance.selected_theme.styles)   
      styles.uniq!
      
      page_css = styles.map do |style_url|
        "<link type=\"text/css\" rel=\"stylesheet\" href=\"#{style_url}\"/>"
      end  
            
      return page_css.join
    
    end
   
    #
    # Get the scripts
    #
    def get_scripts(context)
    
      scripts = []
      scripts.concat(Themes::ThemeManager.instance.selected_theme.scripts)       
      scripts.concat(Plugins::Plugin.plugin_invoke_all('page_script', context))
      scripts.uniq!
      
      page_scripts = scripts.map do |script_url|
        "<script type=\"text/javascript\" src=\"#{script_url}\"></script>"
      end  
    
      return page_scripts.join
    
    end
            
    #
    # Executes the preprocessors the get the sections of the page
    #
    def pre_processors(context)
      
      # Load the variables hash with the pre processors results

      Plugins::Plugin.plugin_invoke_all('page_preprocess', context).each do |preprocessor|
        preprocessor.each do |key, value| 
          if not @variables.has_key?(key.to_sym)             
            @variables.store(key.to_sym,[])  
          end     
          @variables[key.to_sym].concat(value) 
        end
      end
      
      result = {}     

      # join the renders of each variable components
     
      @variables.each do |key, page_components| 
          
          page_components.sort! {|x,y| y.weight<=>x.weight} # Sort the elements by weight

          render_page_components = ''
          
          page_components.each do |page_component|  
            render_page_components << page_component.render 
          end
 
          if String.method_defined?(:force_encoding)
            render_page_components.force_encoding('utf-8')
          end
           
          result.store(key.to_sym, render_page_components)

      end

      return result
    
    end

      
    # Finds the template to render the page
    #
    #
    def find_template(context, layout)
      
       app = context[:app]

       # Search in theme path
       page_template_path = Themes::ThemeManager.instance.selected_theme.resource_path("#{layout}.erb",'template') 
         
       # Search in the project
       if not page_template_path
         path = app.get_path(layout)                                 
         page_template_path = path if File.exist?(path)
       end
         
       page_template_path
       
    end

  end #Page
   
end #Site 