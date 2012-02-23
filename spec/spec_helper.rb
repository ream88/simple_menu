$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'minitest/autorun'
require 'minitest/spec'
require 'purdytest'
require 'simple_menu'

Dir[File.expand_path('../support/*.rb', __FILE__)].each { |file| require file }