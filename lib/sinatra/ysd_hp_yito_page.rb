require 'ui/ysd_ui_page_builder'
require 'ysd_md_cms' unless defined?ContentManagerSystem::Content

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

          content = ContentManagerSystem::Content.new_from_file(path)
          
          template_engine = if content.respond_to?(:template_engine)
                              content.template_engine 
                            else
                              SystemConfiguration::Variable.get_value('site_template_engine') || 'erb'
                            end
          
          page_template = Tilt[template_engine].new { content.body }
          page_body  = page_template.render(self, options[:locals])     
          if String.method_defined?(:force_encoding)
            page_body.force_encoding('utf-8')
          end          

          the_page = UI::Page.new(:title => content.title, 
                                  :author => content.author, 
                                  :keywords => content.keywords, 
                                  :language => content.language, 
                                  :description => content.description, 
                                  :summary => content.summary,
                                  :content => page_body )

          page(the_page, options)
            
        else
          #puts "Resource Not Found. Path= #{request.path_info} Resource name= #{resource_name}"
          status 404
        end
        
      rescue Errno::ENOENT => error
          #puts "Resource Not Found. Path= #{request.path_info} Resource name= #{resource_name} Error= #{error}"
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

  end #PageBuilderHelper
end #Sinatra 
  