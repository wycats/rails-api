module RailsDocs
  class Namespace
    def initialize(namespace)
      @namespace = namespace
      methods    = YARD::RailsHelpers.public_api_methods(@namespace)
      @methods   = methods.sort_by(&:name)
    end

    def public_methods(desired_scope)
      result = []

      @methods.each do |method|
        if method.scope == :class
          result << method if desired_scope == :class
        elsif desired_scope == :class
          result << method if method.parent.path =~ /::ClassMethods$/
        else
          result << method unless method.parent.path =~ /::ClassMethods$/
        end
      end

      result
    end

    def title
      if @namespace.has_tag?(:title)
        @namespace.tag(:title).text
      elsif @namespace.has_tag?(:purpose)
        @namespace.tag(:purpose).text
      else
        @namespace.name
      end
    end

    def yard_object
      @namespace
    end
  end
end