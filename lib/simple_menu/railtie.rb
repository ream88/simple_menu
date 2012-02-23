require 'simple_menu/view_helpers'

class SimpleMenu::Railtie < Rails::Railtie
  initializer('simple_menu.view_helpers') do
    ActionView::Base.send(:include, SimpleMenu::ViewHelpers)
  end
end