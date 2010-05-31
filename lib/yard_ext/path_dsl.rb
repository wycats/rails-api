require "rbconfig"

module YARD
  class Paths
    def self.load(*args, &block)
      new(*args, &block).load
    end

    attr_reader :paths

    def initialize(roots = {}, &block)
      @paths  = []
      @stdlib = RbConfig::CONFIG["rubylibdir"]
      @roots  = roots
      instance_eval(&block)
    end

    def stdlib(name)
      path = name.gsub(/-/, '/')
      @paths.concat(Dir["#{@stdlib}/#{path}/**/*.rb"])
    end

    def exclude(file)
      @paths.delete_if do |file|
        File.basename(file) == file.sub(/(\.rb)?$/, '.rb')
      end
    end

    def load
      YARD::Registry.load(@paths)
    end

    def method_missing(meth, *args, &block)
      if root = @roots[meth]
        options = args.last.is_a?(Hash) ? args.pop : {}

        if first = options[:first]
          Array(first).each do |path|
            @paths << "#{root}/#{path}.rb"
          end
        end

        @paths.concat(Dir["#{root}/#{args.join("/")}/**/*.rb"])
      else
        super
      end
    end
  end
end