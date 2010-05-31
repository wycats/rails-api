class MethodPrinter
  def initialize(meths)
    @max_meth_size = meths.max {|a,b| a.name.size <=> b.name.size }.name.size + 1
    @grouped_methods = meths.sort_by {|m| m.name }.group_by {|m| [m.scope, m.name] }
  end

  def print_methods(provided_scope)
    @grouped_methods.each do |(scope, name), submethods|
      if scope == provided_scope
        submethods.each_with_index do |meth, i|
          meth_name = meth.delegate ? "#{meth.name} (#{meth.delegate})" : meth.name

          if meth.parent.path =~ /(.*)::ClassMethods/
            parent = YARD::Registry.at($1)
          else
            parent = meth.parent
          end

          if parent.has_tag?(:purpose)
            parent_name = parent.tag(:purpose).text
          else
            parent_name = "XXXXXX (#{parent.path})"
          end

          if i == 0
            puts("%#{@max_meth_size}s | %s" % [meth_name, parent_name])
          else
            puts (" " * (@max_meth_size - 3)) + "... | #{parent_name}"
          end
        end
      end
    end
  end
end