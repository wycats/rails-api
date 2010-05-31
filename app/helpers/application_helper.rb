module ApplicationHelper
  def coderay(text)
    text.gsub(/\<pre(?:\s+lang="(.+?)"(?:\s+data-caption="(.+?)")?)?\>(.+?)\<\/pre\>/m) do
      contents = $3.strip
      content_tag :div, :caption => $2, :class => "code_block" do
        CodeRay.scan(contents, $1).div(:css => :class).html_safe
      end
    end
  end

  def markdown(text)
    text.gsub!(/\+([\w]+)\+/, "<code>\\1</code>")
    text.gsub!(/^\s*(=+)(.*)$/) {|m| ("#" * $1.size) + $2 }
    text.gsub!(/^\s*(Examples?|Parameters|Usage):?\s*$/, "### \\1")
    super
  end

  # Override textilize to syntax highlight code blocks in <pre>
  # TODO double check xss security of this
  def code_markdown(text)
    output, current = "", ""
    s = StringScanner.new(text)

    while char = s.getch
      current << char
      if s.peek(4) == "<pre"
        output << markdown(current)
        current = ""
        code = s.scan_until(%r{</pre>})
        output << coderay(code)
      elsif s.peek(2) =~ /  /m && current =~ /\n\s*\n\Z/
        output << markdown(current)
        current = ""
        code = s.scan_until(%r{(^(?=[^\s])|\Z)})
        min_tabs = code.scan(/^ +/).min.size
        code.gsub!(/^ {#{min_tabs}}/, '')
        lang = code =~ /^\s*<%/ ? "rhtml" : "ruby"
        output << coderay(%{<pre lang="#{lang}">\n#{code}\n</pre>})
      end
    end
    output << markdown(current) unless current.blank?
    output.html_safe
  end
end
