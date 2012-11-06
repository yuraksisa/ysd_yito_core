module UI
  #
  # Base class for entity renders
  #
  class AbstractEntityRender
    
    attr_reader :object, :context, :display
    
    #
    # Creates an entity render
    #
    # @param [Object]
    #   The object to render
    #
    # @param [Hash]
    #   The context
    #
    # @param [String]
    #   The display that tells how to render
    #
    def initialize(object, context, display=nil)
    
      @object = object
      @context = context
      @display = display
    
    end
    
    #
    # Renders the entity
    #
    # @param [Object]
    #
    #  The options to render
    #
    def render(options=nil)
      return nil
    end
  
  end # AbstractEntityRender
end #UI