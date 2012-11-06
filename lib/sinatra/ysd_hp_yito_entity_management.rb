module Sinatra
  #
  # Sinatra Helpers to build entity management pages
  # 
  module YitoEntityManagementHelper
   
    #
    # Load the page
    #
    # @param [String] template
    #   The name of the template to render
    #
    # @param [String] entity_name
    #    The entity name (to extract aspects)
    #
    def load_em_page(template, entity_name, is_child, opts={})

      data = extract_em_request_info(entity_name, is_child)

      locals = opts[:locals] || {}
      
      locals.merge!(data[:locals]) if data.has_key?(:locals)
      locals.merge!(data[:info]) if data.has_key?(:info)

      opts.store(:locals, locals)

      # layout
      if data.has_key?(:params) and data[:params].has_key?('layout') and data[:params]['layout'] == 'no'
      	opts.store(:layout, false)
      end

      load_page(template, opts)

    end
    
    #
    # Extract information from the request
    #
    # /myentity
    # /myentity/new
    # /myentity/edit/:id
    # /myentity/:id
    # 
    # /myentity/:parent_id
    # /myentity/:parent_id/new
    # /myentity/:parent_id/edit/:id
    # /myentity/:parent_id/:id
    #
    # @param [String] entity_name
    #  The entity name (to process the aspects/complements)
    #
    # @param [Boolean] is_child
    #  Is a detail entity management (there is a master entity)
    #
    def extract_em_request_info(entity_name, is_child)
 
      result = {}

      #
      # analize request.path_info to retrieve information
      #
      parts = if is_child
                request.path_info.match(/\/(?<entity>\w+)\/(?<parent_id>\w+)(\/page\/(?<page>\d+))?(\/(?<action>new|edit))?(\/(?<id>\w+))?/)
              else
                request.path_info.match(/\/(?<entity>\w+)(\/page\/(?<page>\d+))?(\/(?<action>new|edit))?(\/(?<id>\w+))?/)
              end     

      if parts
        unless action = parts['action']
          action = if parts['id'].nil?
          	         'list'
                   else
          	         'view'
          	       end
        end 
        info = {}
        info.store(:em_action, action)
        info.store(:em_parent_id, parts['parent_id']) if parts.names.include?('parent_id')
        info.store(:em_id, parts['id']) 
        info.store(:em_page, parts['page']) 
        result.store(:info, info)
      end
      
      #
      # Get the request query string params
      #
      if params=extract_request_query_string
        result.merge!(params)
      end

      #
      # Get the entity complements
      #
      unless entity_name.nil?
        result.store(:locals, render_entity_aspects(entity_name))
      end

      return result

    end
  end #EntityManagementHelper
end #Sinatra