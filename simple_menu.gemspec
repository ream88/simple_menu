# encoding: utf-8
require './lib/simple_menu/version'

Gem::Specification.new do |s|
  s.name         = 'simple_menu'
  s.version      = SimpleMenu::VERSION
  s.author       = 'Mario Uher'
  s.email        = 'uher.mario@gmail.com'
  s.homepage     = 'https://www.github.com/haihappen/simple_menu'
  s.summary      = s.description = 'Super simple and bulletproof menus for your rails app.'

  s.files        = Dir.glob('lib/**/*')
  s.require_path = 'lib'

  s.add_dependency('actionpack', '~> 3.0')
  s.add_dependency('activesupport', '~> 3.0')
  s.add_dependency('nokogiri')

  s.add_development_dependency('minitest')
  s.add_development_dependency('purdytest')
  s.add_development_dependency('rails', '~> 3.0')
end