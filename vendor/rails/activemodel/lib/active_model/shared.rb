module ActiveModel
  module Shared
    extend ActiveSupport::Concern

    def attribute_names
      raise NotImplementedError
    end

    def read_attribute(name)
      send(name)
    end
  end
end