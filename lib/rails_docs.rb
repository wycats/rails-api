require "yard"
require "fileutils"

require "yard_ext/code_objects"
require "yard_ext/handlers"
require "yard_ext/method_printer"
require "yard_ext/tag_library"
require "yard_ext/path_dsl"

rails      = defined?(Rails) ? Rails.application.config.rails_framework_root : File.expand_path("~/Code/rails")
actionpack = "#{rails}/actionpack/lib"

YARD::Paths.load(:rails => rails, :actionpack => actionpack) do
  stdlib "test"
  stdlib "minitest"

  rails      "activesupport/lib"
  actionpack "abstract_controller"
  actionpack "action_dispatch"
  actionpack "action_controller"
  
  exclude    "jdom"
end

require "rails_docs/path_helpers"
require "rails_docs/filters"
require "rails_docs/rails_helpers"

def display_method(meth)
  if meth.parent.path =~ /ClassMethods$/
    ".#{meth.name}"
  else
    "##{meth.name}"
  end
end

base = YARD::Registry.at("ActionController::Base")
YARD::RailsHelpers.include_class_methods(base)

module RailsDocs
end

# base.inheritance_tree(true).each do |mixin|
#   next if mixin.docstring.empty? || (!mixin.has_tag?(:purpose) && !mixin.has_tag?(:title))
#   meths = YARD::RailsHelpers.has_public_methods?(mixin)
#   next unless meths
# 
#   puts "----------------------"
#   puts mixin
#   puts mixin.tag(:title).text if mixin.has_tag?(:title)
#   puts mixin.tag(:purpose).text unless mixin.has_tag?(:title)
#   klass, instance = meths.partition {|m| m.parent.path =~ /ClassMethods$/ }
#   
#   puts "Class Methods: #{klass.map(&:name).join(", ")}" if klass.any?
#   puts "Instance Methods: #{instance.map(&:name).join(", ")}" if instance.any?
#   # puts
#   # puts mixin.docstring
#   puts "======================"
#   puts
#   puts
#   puts
# end

# meths = YARD::RailsHelpers.public_api_methods(base)

# printer = MethodPrinter.new(meths)
# 
# puts "Class methods:"
# printer.print_methods(:class)
# 
# puts
# puts
# 
# puts "Instance methods:"
# printer.print_methods(:instance)
