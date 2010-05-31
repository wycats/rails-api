require 'action_dispatch/http/request'
require 'action_dispatch/http/response'

module ActionController
  # @purpose Delegating controller methods to ActionDispatch::Request
  module RackDelegation
    extend ActiveSupport::Concern

    delegate :headers, :status=, :location=, :content_type=,
             :status, :location, :content_type, :to => "@_response"

    # @api private
    def dispatch(action, request)
      @_response = ActionDispatch::Response.new
      @_response.request = request
      super
    end

    def params
      @_params ||= @_request.parameters
    end

    def response_body=(body)
      response.body = body if response
      super
    end

    def reset_session
      @_request.reset_session
    end
  end
end
