module UI
  #
  # It represents a page
  #
  class Page
     
     attr_accessor :title
     attr_accessor :styles
     attr_accessor :scripts
     attr_accessor :author     
     attr_accessor :keywords   
     attr_accessor :language    
     attr_accessor :description 
     attr_accessor :content
     attr_accessor :variables  

     def initialize(opts)
 
       @title = opts[:title] if opts.has_key?(:title)
       @styles= opts[:styles] if opts.has_key?(:styles)
       @scripts= opts[:scripts] if opts.has_key?(:scripts)
       @author= opts[:author] if opts.has_key?(:author)
       @keywords= opts[:keywords] if opts.has_key?(:keywords)
       @language= opts[:language] if opts.has_key?(:language)
       @description= opts[:description] if opts.has_key?(:description)
       @summary = opts[:summary] if opts.has_key?(:summary)
       @content = opts[:content] if opts.has_key?(:content)
       @variables = opts[:variables] if opts.has_key?(:variables)

     end

  end
end