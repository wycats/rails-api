module MainHelper
  def tree_link(text, options = {})
    html_class  = ["icon"]
    html_class << "file" if options[:file]
    html_class << "open" if options[:open]
    content_tag(:span, "&nbsp;".html_safe, :class => html_class.join(" ")) <<
    link_to(text)
  end

  def overview
    {"ActionController::Base" =>
      {
        "Layouts"                     =>  "Layouts",
        "View Helpers"                =>  "Helpers",
        "Basic Authentication"        =>  "HttpAuthentication::Basic",
        "Token Authentication"        =>  "HttpAuthentication::Token",
        "CSRF Mitigation"             =>  "RequestForgeryProtection",
        "respond_to and respond_with" =>  "MimeResponds",
        "Caching"                     =>  "Caching",
        "Action Caching"              =>  "Caching::Actions",
        "Fragment Caching"            =>  "Caching::Fragments",
        "Page Caching"                =>  "Caching::Pages",
        "Cache Sweeping"              =>  "Caching::Sweeping"
      }
    }
  end

  def display_method_signature(meth)
    param_meth = meth.is_alias? ? meth.parent.child(meth.parent.aliases[meth]) : meth

    params = param_meth.parameters.map do |name, default|
      default ? "#{name}=#{default}" : name
    end.join(", ")

    "## #{meth.name}(#{params})\n\n#{param_meth.docstring}\n".html_safe
  end

  def class_list
    render :partial => "method", :collection => @class_methods.uniq_by(&:name)
  end

  def instance_list
    render :partial => "method", :collection => @instance_methods.uniq_by(&:name)
  end
end
