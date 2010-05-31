module ActionController
  class Base < Metal
    abstract!

    # @api plugin
    def self.without_modules(*modules)
      modules = modules.map do |m|
        m.is_a?(Symbol) ? ActionController.const_get(m) : m
      end

      MODULES - modules
    end

    original_ancestors = ancestors.dup

    include AbstractController::Layouts
    include AbstractController::Translation

    include Helpers
    include HideActions
    include UrlFor
    include Redirecting
    include Rendering
    include Renderers::All
    include ConditionalGet
    include RackDelegation
    include SessionManagement
    include Caching
    include MimeResponds
    include PolymorphicRoutes
    include ImplicitRender

    include Cookies
    include Flash
    include RequestForgeryProtection
    include Streaming
    include RecordIdentifier
    include HttpAuthentication::Basic::ControllerMethods
    include HttpAuthentication::Digest::ControllerMethods
    include HttpAuthentication::Token::ControllerMethods

    # Add instrumentations hooks at the bottom, to ensure they instrument
    # all the methods properly.
    include Instrumentation

    # Before callbacks should also be executed the earliest as possible, so
    # also include them at the bottom.
    include AbstractController::Callbacks

    # The same with rescue, append it at the end to wrap as much as possible.
    include Rescue

    # Rails 2.x compatibility
    include ActionController::Compatibility

    MODULES = ancestors - original_ancestors

    def self.inherited(klass)
      ::ActionController::Base.subclasses << klass.to_s
      super
      klass.helper :all
    end

    # @api plugin
    def self.subclasses
      @subclasses ||= []
    end

    # TODO Move this to the appropriate module
    config_accessor :assets_dir, :asset_path, :javascripts_dir, :stylesheets_dir

    ActiveSupport.run_load_hooks(:action_controller, self)
  end
end

require "action_controller/deprecated/base"