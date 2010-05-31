module ActionController
  module ImplicitRender
    # @api private
    def send_action(*)
      ret = super
      default_render unless response_body
      ret
    end

    # @api private
    def default_render
      render
    end

    # @api private
    def method_for_action(action_name)
      super || begin
        if template_exists?(action_name.to_s, _prefix)
          "default_render"
        end
      end
    end
  end
end