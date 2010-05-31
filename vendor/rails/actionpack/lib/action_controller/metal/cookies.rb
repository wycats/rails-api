module ActionController #:nodoc:
  # @purpose Cookies
  module Cookies
    extend ActiveSupport::Concern

    include RackDelegation

    included do
      helper_method :cookies
    end

    def cookies
      request.cookie_jar
    end
  end
end
