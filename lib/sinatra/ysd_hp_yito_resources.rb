require 'ysd_core_themes' unless defined?Themes::ThemeManager
module Sinatra
  #
  # Sinatra Helper to load resources
  #
  module YitoResourcesLoaderHelper
    
    #
    # It serves an static resource (css, js, img)
    #
    #
    # @param [String] resource_path
    #  The resource path. For example : /img/my-image.jgp
    # 
    # @param [String] local_folder
    #  Extension local folder which contains static resources
    #
    # @param [String] extension
    #  The module which holds the resource
    #
    # @return
    #
    def serve_static_resource(resource_path, local_folder, extension=nil)
    
       #puts "searching: #{resource_path} * #{local_folder} * #{File.join(local_folder, resource_path)}"     

       # Try to locate the resource in the theme
       file_path = Themes::ThemeManager.instance.selected_theme.resource_path(resource_path, 'static', extension)

       if file_path
         send_file(file_path)
       else
         # Try to locate the resource in the local folder
         file_path = File.join(File.expand_path($0).gsub($0,''), 'public', resource_path)
         if File.exist?(file_path)
           send_file(file_path)
         else
           # Try to locate the resouce in a gem
           file_path = File.expand_path(File.join(local_folder, resource_path))
           if File.exist?(file_path)
             send_file(file_path)
           else
             pass
           end
         end
       end

    end
  
    # ========== UTILITIES TO BUILD A WEB PAGE ================
      
    #
    # Includes a template by its path. 
    #
    # You can use it to build complex views with more than one file.
    #
    # It's like the require 'resource_name'
    #
    # @param [String] resource_name
    #   The "subview" to include
    #
    # @return [String]
    #   The resource processed with the template system
    #
    # TODO Use the default_template to load the file 
    #
    def include(resource_name, options={})
    
      if path=get_path(resource_name)
        erb File.read(path), {:layout => false, :locals => options}    
      end
      
    end    
  
    # ========= UTILITIES FOR RENDERING BLOCKS ================
    

    # Partial rendering : A way to include blocks in your views. 
    #  
    # The "partial" is stored in the views folder, starting with a underscore character.
    #
    #
    # @param [String] template
    #   The template name (which will be extracted from the sinatra view's system)
    #
    # @return [String]
    #   The template rendered
    #
    def partial(template, *args)
       template_array = template.to_s.split('/')
       template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
       options = args.last.is_a?(Hash) ? args.pop : {}
       options.merge!(:layout => false)
 
       if collection = options.delete(:collection) then
         data = collection.inject([]) do |buffer, member|
                  buffer << erb(:"#{template}", options.merge(:layout =>
                  false, :locals => {template_array[-1].to_sym => member}))
                end
         data.join("\n")
       else
         if (template_content = Plugins::Plugin.plugin_invoke_all('page_layout', 
                        {:app => self}, template[1,template.length]).first) and 
           !template_content.empty?
           page_template = Tilt.new('erb') { template_content }
           page_render = page_template.render(app, options)
         else 
           erb(:"#{template}", options)
         end  

       end
    end
    
    # You can also use block to render a partial
    
    alias :block :partial
 
    # ============== UTILS =============================    
    
    # Searching content in the directory structure
    
    #        
    # Get the view full path using the functionalitiy of sinatra's find_template
    #
    # @param [String] view
    #
    #   The view name
    #
    #
    def get_path(resource_name)
        
        #puts "searching path for: #{resource_name}"
        
        path = nil
        found = false
 
        find_template(settings.views, resource_name, Tilt['erb']) do |file|
          path ||= file
          if found=File.exists?(file)
            path = file
            break
          end
        end
          
        #puts "searching path for: #{resource_name} result : #{found} (#{path})"
        
        (found)?path:(nil)
        
    end
    
    #
    # Find resources which names matches the regular expression
    #
    # @param resource_regexp Regular expresion
    #
    # @return Array
    #
    def find_resources(resource_regexp)

      views_list = Array(settings.views).clone
      views_list << File.join(Themes::ThemeManager.instance.selected_theme.root_path, 'template')

      resources = views_list.inject([]) do |result, view_directory|
         Dir.foreach(view_directory) do |view_directory_file|
           result << view_directory_file if File.file?(File.join(view_directory, view_directory_file)) and resource_regexp.match(view_directory_file)
         end
         result
      end

      resources.sort.uniq

    end

    # ============== SINATRA EXTENSIONS =============================
    
    #
    # It overwrite the find_template sinatra method to process an array of views
    # folders instead of a unique views forlder.
    #
    # It takes the locale into account to get localized views
    #
    def find_template(views, name, engine, &block)
      
      # Add the selected theme template directory to the views directories
      
      #views_list = Array(views).clone
      #views_list << File.join(Themes::ThemeManager.instance.selected_theme.root_path, 'template')


      # First: Include the theme folder and then project (in order to override)
      views_list = []
      views_list << File.join(Themes::ThemeManager.instance.selected_theme.root_path, 'template')
      views_list.concat(Array(views))

      # Try to search the template in locale
      if (session[:locale])
      
        Array(views_list).each do |view|
          super(view, File.join(session[:locale],name.to_s).to_sym, engine, &block)
        end
        
      end
      
      #puts "TF : Not found #{name} en locale, vamos a buscar en ..."
      
      Array(views_list).each do |view|
        super(view, name, engine, &block)
      end
    
      #puts "TF : Not found #{name}"
    
    end      
    

  end #YitoHelper
end #Sinatra 
  
