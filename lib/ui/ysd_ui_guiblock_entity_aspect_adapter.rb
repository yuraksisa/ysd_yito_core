module UI
  #
  #
  #
  class GuiBlockEntityAspectAdapter

    attr_reader :weight, :in_group, :show_on_new, :show_on_edit, :show_on_view, :render_weight, :render_in_group, :gui_block 

    def initialize(gui_block, weight, in_group, show_on_new, show_on_edit, show_on_view, render_weight, render_in_group)
      @weight = weight
      @in_group = in_group
      @show_on_new = show_on_new
      @show_on_edit = show_on_edit
      @show_on_view = show_on_view
      @render_weight = render_weight
      @render_in_group = render_in_group
      @gui_block = gui_block	 
    end

    def get_aspect(context={})
      return self
    end

  end
end