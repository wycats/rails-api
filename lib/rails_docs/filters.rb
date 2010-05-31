[:before, :after, :around].each do |filter|
  YARD.parse_string <<-RUBY
    module AbstractController
      # @purpose Running code before, after, or around actions
      module Callbacks
        module ClassMethods
          # Append a before, after or around filter. See _insert_callbacks
          # for details on the allowed parameters.
          def #{filter}_filter(*names, &blk)
            _insert_callbacks(names, blk) do |name, options|
              set_callback(:process_action, :#{filter}, name, options)
            end
          end

          # Prepend a before, after or around filter. See _insert_callbacks
          # for details on the allowed parameters.
          def prepend_#{filter}_filter(*names, &blk)
            _insert_callbacks(names, blk) do |name, options|
              set_callback(:process_action, :#{filter}, name, options.merge(:prepend => true))
            end
          end

          # Skip a before, after or around filter. See _insert_callbacks
          # for details on the allowed parameters.
          def skip_#{filter}_filter(*names, &blk)
            _insert_callbacks(names, blk) do |name, options|
              skip_callback(:process_action, :#{filter}, name, options)
            end
          end

          # *_filter is the same as append_*_filter
          alias_method :append_#{filter}_filter, :#{filter}_filter
        end
      end
    end
  RUBY
end