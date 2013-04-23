require 'json'
require 'uri'
require 'ysd_md_yito'

module Sinatra
  module YitoJsonRequestExtractor
    
    #
    # Extract the request information, matches to a model properties and symbolize keys
    #
    def body_as_json(model=nil)

      request.body.rewind
      
      extracted_request = JSON.parse(URI.unescape(request.body.read))
      
      if model and model.respond_to?(:properties)
        extracted_request.keep_if do |key, value| 
           model.properties.field_map.keys.include?(key) or model.relationships.named?(key)
        end
      end
      
      extracted_request.symbolize_keys!

      return extracted_request

    end



  end
end