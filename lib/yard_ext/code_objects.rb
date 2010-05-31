module YARD::CodeObjects
  class NamespaceObject
    def modules
      children.select {|o| o.type == :module }
    end
  end

  class MethodObject
    class Model
      def self.model_name
        @model_name ||= ActiveModel::Name.new(Method)
      end

      def intialize(code)
        @code = code
      end
    end

    attr_accessor :delegate, :dynamic

    def to_model
      Model.new(self)
    end

    def to_param
      path
    end
  end
end
