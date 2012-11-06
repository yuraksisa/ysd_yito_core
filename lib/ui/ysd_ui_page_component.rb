module UI
  class PageComponent

    attr_accessor :component
    attr_accessor :weight
    attr_accessor :render
 
    def initialize(opts={})

      @component = opts[:component] if opts.has_key?(:component)
      @weight = opts[:weight] if opts.has_key?(:weight)
      @render = opts[:render] if opts.has_key?(:render)

    end

  end
end