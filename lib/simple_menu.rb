require 'active_support/core_ext'
require 'nokogiri'

require 'simple_menu/railtie' if defined?(Rails)
require 'simple_menu/version'

class SimpleMenu
  def initialize(template, &block)
    self.template = template
    self.menu = []
    self.options = {
      save_with: NOKOGIRI::FORMAT | NOKOGIRI::NO_DECLARATION,
      indent: 2
    }
    
    add(&block) if block_given?
  end

  def add(&block)
    instance_eval(&block)
    self
  end

  def method_missing(name, *args, &block)
    self << template.send(name, *args, &block)
  end

  def to_s
    Nokogiri::XML::Builder.new do |xml|
      xml.ul do
        each do |item|
          xml.li do
            xml << item
          end
        end
      end
    end.to_xml(options).html_safe
  end

private
  attr_accessor :menu, :template, :options
  delegate :each, :<<, to: :menu

  NOKOGIRI = Nokogiri::XML::Node::SaveOptions
end