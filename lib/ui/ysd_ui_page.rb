module UI
  #
  # It represents a page
  #
  class Page
     
     attr_accessor :type
     attr_accessor :title
     attr_accessor :styles
     attr_accessor :styles_source
     attr_accessor :scripts
     attr_accessor :scripts_source
     attr_accessor :author     
     attr_accessor :keywords   
     attr_accessor :language    
     attr_accessor :description 
     attr_accessor :content
     attr_accessor :variables
     attr_accessor :cache_page_life  

     def initialize(opts)
       
       @type = opts[:type] if opts.has_key?(:type)
       @title = opts[:title] if opts.has_key?(:title)
       @styles= opts[:styles] if opts.has_key?(:styles)
       @scripts= opts[:scripts] if opts.has_key?(:scripts)
       @scripts_source = opts[:scripts_source] if opts.has_key?(:scripts_source)
       @styles_source = opts[:styles_source] if opts.has_key?(:styles_source)
       @author= opts[:author] if opts.has_key?(:author)
       @keywords= opts[:keywords] if opts.has_key?(:keywords)
       @language= opts[:language] if opts.has_key?(:language)
       @description= opts[:description] if opts.has_key?(:description)
       @summary = opts[:summary] if opts.has_key?(:summary)
       @content = opts[:content] if opts.has_key?(:content)
       @variables = opts[:variables] if opts.has_key?(:variables)
       @cache_page_life = opts[:cache_page_life] if opts.has_key?(:cache_page_life)

     end

  end
end