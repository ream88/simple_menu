module SimpleMenu::ViewHelpers
  def simple_menu(&block)
    SimpleMenu.new(self, &block)
  end
end