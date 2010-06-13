class MainController < ApplicationController
  def index
    klass               = RailsDocs::Namespace.new(YARD::Registry.at("ActionController::Base"))
    @class_methods      = klass.public_methods(:class)
    @instance_methods   = klass.public_methods(:instance)

    if params[:name]
      @method           = YARD::Registry.at(params[:name])

      name              = @method.path.gsub(/::ClassMethods$/, "")
      @module           = RailsDocs::Namespace.new(YARD::Registry.at(name))
      @current_class    = current_methods(@class_methods).presence
      @current_instance = current_methods(@instance_methods).presence
    end
  end

private

  def current_methods(list)
    methods = if @module
      list.select do |m|
        m.parent.path =~ /#{@module.yard_object}(::ClassMethods)?/
      end
    else
      list
    end

    methods.uniq_by {|m| m.name }
  end

end
