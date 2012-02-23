class SimpleMenu
  module ViewHelpers
    def simple_menu(&block)
      SimpleMenu.new(self, &block)
    end
  end
end