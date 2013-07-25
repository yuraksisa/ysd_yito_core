require 'ui/ysd_ui_page_builder'
require 'yaml'

module Sinatra
  #
  # Sinatra Helper functions to include page generation methods
  #
  module YitoPageBuilderHelper

    # Renders a content getting a web page
    #
    # @param [UI::Page] page
    #  The page to render
    # 
    # @param [Hash] options
    #  Options to the render
    #
    def page(page, options={})
      
      if SystemConfiguration::Variable.get_value('site.cache.enabled','false').to_bool and
         user and user.belongs_to?('anonymous')
        cache_control :public, :max_age => (page.cache_page_life || SystemConfiguration::Variable.get_value('site.cache.page_life'))
      end                    
      
      page = UI::PageBuilder.build(page, {:app => self}, options)
       
    end

    #
    # Loads a views template (which can includes metadata)
    #
    # If you need some information in your resource, as title, author, creation
    # date, use this method instead of the templates methods (erb, haml, ...)
    # because it reads the file and extract the metadata.
    # 
    # For example :
    # -------------
    #
    #   If you have a resource, myarticle.erb, you can add it extra information. Then
    #   when you need to render the view, instead of use erb :myarticle, you can
    #   use load_page(:myarticle), and the information will be extracted.
    #   
    #    myarticle.rb
    #
    #     title: Article title
    #     author: me
    #     creation-date: 2011-01-11T10:00:00+01:00
    #     template: erb
    #
    #     here goes the view text
    #
    # 
    # @param [String] resource_name
    #
    # @param [Hash] options
    #   A set of options used to render the view 
    #
    def load_page(resource_name, options={})       
      
      begin
            
        resource_name = resource_name.to_s if resource_name.is_a?(Symbol)
              
        if path=get_path(resource_name) # Search the resource in the views path            
          
          page_data = parse_page_file(path).symbolize_keys

          template_engine = if page_data.has_key?(:template_engine)
                              page_data[:template_engine] 
                            else
                              SystemConfiguration::Variable.get_value('site_template_engine') || 'erb'
                            end
          
          page_template = Tilt[template_engine].new { page_data[:body] }
          page_body  = page_template.render(self, options[:locals])     
          
          if String.method_defined?(:force_encoding)
            page_body.force_encoding('utf-8')
          end          

          the_page = UI::Page.new(:title => options[:page_title] || page_data[:title], 
                                  :author => options[:page_author] || page_data[:author], 
                                  :keywords => options[:page_keywords] || page_data[:keywords], 
                                  :language => options[:page_language] || page_data[:language], 
                                  :description => options[:page_description] || page_data[:description], 
                                  :summary => options[:page_summary] || page_data[:summary],
                                  :content => page_body )

          page(the_page, options)
            
        else
          puts "Resource Not Found. Path= #{request.path_info} Resource name= #{resource_name}"
          status 404
        end
        
      rescue Errno::ENOENT => error
          puts "Resource Not Found. Path= #{request.path_info} Resource name= #{resource_name} Error= #{error}"
          status 404
      end  
    
    end    
    
    #
    # Extract request query string
    #
    # A set if parameters in the form of:
    #
    #   attribute_1=value_1&attribute_2=value_2
    #  
    # @return [Hash]
    #
    #  A hash of param and values
    #
    def extract_request_query_string
      
      result = {}

      if request.query_string.length > 0
        result.store(:params, Hash[request.query_string.split('&').map {|x| x.split('=')}])
      end

      return result

    end

    private

    # Parse a file and gets the metadata hold
    # 
    # @param [String] file_path
    #   The file to process
    #
    # @return [Hash]
    #   A hash with the metadata
    #  
    def parse_page_file(file_path)
  
         result = {}
         metadata = []
         remaining = ''
  
         File.open(file_path) do |file|
        
           while (not file.eof?)
              line = file.readline            
              if match = line.match(/\w*:\s[\w|\s]*/)
                 metadata.push(line)
              else
                 remaining << line if not line.match(/^\n|\n\r$/)
                 break
              end
           end 
         
           remaining << file.read # Reads the rest of the document

           result = {}
           
           if metadata and metadata.length > 0 
            result = YAML::load(metadata.join)
           end
           
           result.store(:body, remaining) if remaining
    
         end 
 
         return result  
  
    end     

  end #PageBuilderHelper
end #Sinatra 
  