module UI
  #
  #
  #
  class GuiBlockEntityAspectAdapter

    attr_reader :gui_block, :weight, :in_group, :show_on_new, :show_on_edit, :show_on_view, :render_weight, :render_in_group 

    def initialize(gui_block, opts={})
      @gui_block = gui_block
      @weight = 0
      @in_group = false
      @show_on_new = true
      @show_on_edit = true
      @show_on_view = true
      @render_weight = 0
      @render_in_group = false      
      @weight = opts[:weight] if opts.has_key?(:weight)
      @in_group = opts[:in_group] if opts.has_key?(:in_group)
      @show_on_new = opts[:show_on_new] if opts.has_key?(:show_on_new)
      @show_on_edit = opts[:show_on_edit] if opts.has_key?(:show_on_edit)
      @show_on_view = opts[:show_on_view] if opts.has_key?(:show_on_view)
      @render_weight = opts[:render_weight] if opts.has_key?(:render_weight)
      @render_in_group = opts[:render_in_group] if opts.has_key?(:render_in_group)
    end

    def get_aspect(context={})
      return self
    end

  end
end