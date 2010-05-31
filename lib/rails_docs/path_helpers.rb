url_for = YARD::Registry.at("ActionDispatch::Routing::UrlFor")

[:url, :path].each do |type|
  YARD::Registry.register YARD::CodeObjects::MethodObject.new(url_for, "[dynamic]_#{type}", :instance) { |o|
    o.parameters = [["*args", nil], ["&block", nil]]
    o.source = <<-RUBY.gsub(/^ {4}/, '')
      def [dynamic]_#{type}(*args, &block)
        options = hash_for_[dynamic]_#{type}

        if args.any?
          options[:_positional_args] = args

          # an Array of the route's dynamic segments
          options[:_positional_keys] = [dynamic]
        end

        url_for(options)
      end
    RUBY
    o.signature = "def [dynamic]_#{type}(*args, &block)"
    o.docstring = <<-TXT.gsub(/ {6}/, '')
      Returns the #{type} for the named route used. For
      each named route, Rails will generate one of these
      methods.

      For instance, if you had the following in your router:

        match "/posts/:id" => "posts#show", :as => :posts

      You could use the following helper in your controllers
      and views:

        posts_#{type}(1)

      which would return:

        "/posts/1"
    TXT
    o.dynamic   = true
  }
end