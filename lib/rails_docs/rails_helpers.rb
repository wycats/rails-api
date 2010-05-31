module YARD
  module RailsHelpers
    def self.include_class_methods(base)
      base.inheritance_tree(true).each do |mod|
        mod.modules.each do |submod|
          if submod.path == "#{mod.path}::ClassMethods"
            base.class_mixins << submod
          end
        end
      end
    end

    def self.has_public_methods?(mod)
      options = {:inherited => false, :included => false}
      meths   =  mod.meths(options)

      if class_methods = YARD::Registry.at("#{mod.path}::ClassMethods")
        meths += class_methods.meths(options)
      end

      winnowed = winnow_methods(meths)
      winnowed.empty? ? nil : winnowed
    end

    def self.winnow_methods(meths, disallowed = %w(deprecated private plugin))
      # reject private methods or methods beginning with _
      meths.reject! {|m| m.name =~ /^_/ || m.visibility != :public }

      # reject self.inherited and #initialize
      meths.reject! do |m|
        (m.scope == :class && m.name == :inherited) ||
        (m.parent.path =~ /ClassMethods$/ && m.name == :inherited) ||
        (m.scope == :instance && m.name == :initialize)
      end

      # reject methods marked deprecated, private or plugin
      meths.reject! do |m|
        parent_hidden = m.parent.has_tag?(:api) && begin
          disallowed.include?(m.parent.tag(:api).text)
        end

        method_hidden = m.has_tag?(:api) && begin
          disallowed.include?(m.tag(:api).text)
        end

        parent_hidden || method_hidden
      end

      meths
    end

    def self.public_api_methods(base)
      meths = base.meths(:inherited => true, :included => true, :all => true).uniq
      winnow_methods(meths)
    end
  end
end