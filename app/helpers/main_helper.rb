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
        "Layouts"                     =>  "AbstractController::Layouts",
        "View Helpers"                =>  "ActionController::Helpers",
        "Basic Authentication"        =>  "ActionController::HttpAuthentication::Basic",
        "Token Authentication"        =>  "ActionController::HttpAuthentication::Token",
        "CSRF Mitigation"             =>  "ActionController::RequestForgeryProtection",
        "respond_to and respond_with" =>  "ActionController::MimeResponds",
        "Caching"                     =>  "ActionController::Caching",
        "Action Caching"              =>  "ActionController::Caching::Actions",
        "Fragment Caching"            =>  "ActionController::Caching::Fragments",
        "Page Caching"                =>  "ActionController::Caching::Pages",
        "Cache Sweeping"              =>  "ActionController::Caching::Sweeping"
      }
    }
  end

  def display_method_signature(meth)
    param_meth = meth.is_alias? ? meth.parent.child(meth.parent.aliases[meth]) : meth

    params = param_meth.parameters.map do |name, default|
      default ? "#{name}=#{default}" : name
    end.join(", ")

    "<h2 id='#{meth.name}'>#{meth.name}(#{params})</h2>\n\n#{param_meth.docstring}\n".html_safe
  end

  def class_list
    render :partial => "method", :collection => @class_methods.uniq_by(&:name)
  end

  def instance_list
    render :partial => "method", :collection => @instance_methods.uniq_by(&:name)
  end
end
