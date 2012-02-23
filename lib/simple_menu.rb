require 'active_support/core_ext'
require 'nokogiri'

require 'simple_menu/railtie' if defined?(Rails)
require 'simple_menu/version'

class SimpleMenu
  def initialize(template, &block)
    self.template = template
    self.menu = []
    self.options = {
      save_with: Nokogiri::XML::Node::SaveOptions::FORMAT |
                 Nokogiri::XML::Node::SaveOptions::NO_DECLARATION |
                 Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS,
      indent: 2
    }
    
    add(&block) if block_given?
  end

  def add(index = menu.length, &block)
    menu.insert(index, instance_eval(&block))
  end

  def before(href_or_name, &block)
    add(index_of(href_or_name), &block)
  end

  def after(href_or_name, &block)
    add(index_of(href_or_name) + 1, &block)
  end

  def method_missing(name, *args, &block)
    template.send(name, *args, &block)
  end

  def to_s
    Nokogiri::XML::Builder.new do |xml|
      xml.ul do
        each do |item|
          xml.li do
            xml << highlight_current(item)
          end
        end
      end
    end.to_xml(options).html_safe
  end

private
  attr_accessor :menu, :template, :options
  delegate :each, to: :menu

  def element(item)
    Nokogiri::HTML(item).children.search('body > *')
  end

  def href(element)
    href = element.attribute('href')
    href.present? ? href.value : ''
  end

  def highlight_current(item)
    element(item).tap do |element|
      element.add_class(:active) if element.present? && template.url_for == href(element)
    end.to_html
  end

  def index_of(href_or_name)
    each.with_index do |item, index|
      element = element(item)
      next unless element.present?
      
      return index if element.text.match(href_or_name) || href(element).match(href_or_name)
    end.length
  end
end