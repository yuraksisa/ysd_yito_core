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
      page_builder = PageBuilder.new(page, Themes::ThemeManager.instance.selected_theme.regions)
    
      # Builds the page
      page_builder.build_page(context, options)
              
    end

    # ---------------------------------------------

    #
    # Constructor
    #
    # @param [Object] page
    #   The page to render
    #     
    # @param [Array] regions
    #
    #   The page regions (retrieved from the theme)
    #
    def initialize(page, regions)
    
      @page = page
      @variables = {}
    
      regions.each do |region|
        @variables.store(region.to_sym, []) 
      end
    
    end
 
    # Builds a page
    #
    #
    # @param [Object] context
    #   The context in which the render will be done
    #
    # @param [Hash] options
    #   Render options
    #
    def build_page(context, options={})
      
      app = context[:app]

      @page.admin_page = is_admin_page?(app)

      locals = options[:locals] || {} 
      layout = if options.has_key?(:layout)
                 if options[:layout] == 'no' || options[:layout] == 'false' || options[:layout] == false
                   'blank'
                 else
                   options[:layout]
                 end
               else 
                 @page.admin_page ? 'page_render_admin' : 'page_render'
               end

      locals.merge!(page_configuration)
      build_styles_scripts(context)
      @page.variables ||= {}
      @page.variables.merge!(pre_processors(context))

      # Search in plugins (page_layout element)
      if template = find_template(context, layout) and not template.strip.empty?
        page_template = Tilt.new('erb') { template }
        page_render = page_template.render(app, locals.merge({:page => @page}))
      else
        # Search in folders
        if page_template_path = find_template_path(context, layout)
          page_template = Tilt.new(page_template_path)
          page_render = page_template.render(app, locals.merge({:page => @page}))          
        else
          @page.content
        end
      end

    end
    
    private
    
    #
    # Check if the page belongs to the admin area
    #
    def is_admin_page?(app)

      page_requested = if app.respond_to?(:request)
                         if app.request.respond_to?(:path_info)
                           app.request.path_info
                         else
                           nil
                         end
                       else
                         nil
                       end

      admin_page = if page_requested 
                     (page_requested.start_with?('/admin') or
                     page_requested.start_with?('/dashboard') or
                     page_requested.start_with?('/profile') or
                     page_requested.start_with?('/mail') or
                     page_requested.start_with?('/community')) and
                     (not page_requested.start_with?('/profile/register'))
                   else
                     false
                   end   

    end

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
    # Configure the page styles and scripts
    #
    def build_styles_scripts(context)

      @page.styles ||= ''

      if @page.styles_source and not @page.styles_source.empty?
         @page.styles_source = <<-STYLE 
           <style type=\"text/css\">
             #{@page.styles_source}
           </style>
         STYLE
      end
      @page.styles_source ||= ''

      if @page.scripts and not @page.scripts.empty?
        scripts_detail = ''
        @page.scripts.each do |script_url|
          scripts_detail << <<-SCRIPT
            "<script type=\"text/javascript\" src=\"#{script_url}\"></script>"
          SCRIPT
        end
        @page.scripts = scripts_detail
      end
      @page.scripts ||= ''

      if @page.scripts_source and not @page.scripts_source.empty? 
         @page.scripts_source = <<-SCRIPT 
           <script type=\"text/javascript\">
              #{@page.scripts_source}
           </script>
         SCRIPT
      end
      @page.scripts_source ||= ''

      @page.styles  << get_styles(context)
      @page.styles_source << get_styles_source(context) 
      @page.scripts << get_scripts(context)
      @page.scripts_source << get_scripts_source(context)

    end

    #
    # Get the styles
    #
    def get_styles(context)
      
      styles = []    
      
      # Theme styles
      if @page.admin_page
        styles.concat(Themes::ThemeManager.instance.selected_theme.backoffice_styles)   
      else
        styles.concat(Themes::ThemeManager.instance.selected_theme.frontend_styles)   
      end
      styles.concat(Themes::ThemeManager.instance.selected_theme.styles)   

      # Plugin styles
      styles.concat(Plugins::Plugin.plugin_invoke_all('page_style', context, @page))

      styles.uniq!
      
      page_css = styles.map do |style_url|
        "<link type=\"text/css\" rel=\"stylesheet\" href=\"#{style_url}\"/>"
      end  
            
      return page_css.join
    
    end
    
    #
    # Get the styles source
    #
    def get_styles_source(context)

      # Plugins styles
      styles = Plugins::Plugin.plugin_invoke_all('page_style_source', context, @page)

      page_css_source = styles.map do |style_source|
        "<style type=\"text/css\">#{style_source}</style>"
      end

      return page_css_source.join

    end

    #
    # Get the scripts
    #
    def get_scripts(context)
    
      scripts = []

      # Theme scripts
      scripts.concat(Themes::ThemeManager.instance.selected_theme.scripts)       
      if @page.admin_page
        scripts.concat(Themes::ThemeManager.instance.selected_theme.backoffice_scripts)
      else
        scripts.concat(Themes::ThemeManager.instance.selected_theme.frontend_scripts)
      end  

      # Plugins scripts
      scripts.concat(Plugins::Plugin.plugin_invoke_all('page_script', context, @page))

      scripts.uniq!
      
      page_scripts = scripts.map do |script_url|
        "<script type=\"text/javascript\" src=\"#{script_url}\"></script>"
      end  
    
      return page_scripts.join
    
    end
    
    #
    # Get the scripts source
    #        
    def get_scripts_source(context)

      # Plugin scripts
      scripts = Plugins::Plugin.plugin_invoke_all('page_script_source', context, @page)
      
      page_scripts = scripts.map do |script_source|
        "<script type=\"text/javascript\">#{script_source}</script>"
      end

      return page_scripts.join

    end

    #
    # Executes the preprocessors the get the sections of the page
    #
    def pre_processors(context)
      
      # Load the variables hash with the pre processors results

      Plugins::Plugin.plugin_invoke_all('page_preprocess', @page, context).each do |preprocessor|
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
          page_components.sort! {|x,y| y.weight<=>x.weight} 
          render_page_components = ''
          
          page_components.each do |page_component|
            if page_component.respond_to?(:render)
              render_page_components << page_component.render
            elsif page_component.is_a?(String)
              render_page_components << page_component
            end
          end
 
          if String.method_defined?(:force_encoding)
            render_page_components.force_encoding('utf-8')
          end
           
          result.store(key.to_sym, render_page_components)
      end

      return result
    
    end
    
    #
    # Find the template
    #
    # @return [String] The template
    #
    def find_template(context, layout)

      Plugins::Plugin.plugin_invoke_all('page_layout', context, layout).join

    end

      
    # Finds the template path to render the page
    #
    # @param [Object]
    # @param [String] layout
    # @return [String] The template path
    #
    def find_template_path(context, layout)
      
       app = context[:app]

       # Search in theme path
       page_template_path = Themes::ThemeManager.instance.selected_theme.
         resource_path("#{layout}.erb",'template') 
         
       # Search in the project
       if not page_template_path and path = app.get_path(layout) 
         page_template_path = path if File.exist?(path)
       end
         
       page_template_path
       
    end

  end #Page
   
end #Site 
