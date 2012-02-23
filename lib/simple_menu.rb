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
  end

  def before(href_or_name, &block)
    @index = index_of(href_or_name)
    instance_eval(&block)
    @index = nil
  end

  def after(href_or_name, &block)
    @index = index_of(href_or_name) + 1
    instance_eval(&block)
    @index = nil
  end

  def method_missing(name, *args, &block)
    menu.insert(index, template.send(name, *args, &block))
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
  delegate :each, to: :menu

  NOKOGIRI = Nokogiri::XML::Node::SaveOptions

  def index
    @index || menu.length
  end

  def index_of(href_or_name)
    each.with_index do |item, index|
      item = Nokogiri::XML(item).children.first
      
      return index if item.text.match(href_or_name) || item[:href].match(href_or_name)
    end
  end
end