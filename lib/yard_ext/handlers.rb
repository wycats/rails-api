class DelegateHandler < YARD::Handlers::Ruby::Base
  handles method_call(:delegate)

  def delegate(*names)
    hash = names.pop
    to   = hash[:to] || hash["to"]

    names.each do |name|
      register YARD::CodeObjects::MethodObject.new(namespace, name, scope) { |o|
        o.parameters = [["*args", nil], ["&block", nil]]
        o.source = "def #{name}(*args, &block)\n  #{to}.#{name}\nend"
        o.signature = "def #{name}(*args, &block)"
        o.docstring = statement.comments.to_s.empty? ? "" : statement.comments
        o.delegate = to
      }
    end
  end

  process do
    instance_eval(statement.source, __FILE__, __LINE__)
  end
end