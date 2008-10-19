class Snippet
  SUBS = Hash.new("")
  SUBS["snip_start_tag"] = "<{"
  SUBS["snip_end_tag"]   = "}>"

  def initialize(snippet, subs = {})
    @snippet = snippet
    @subs = subs
  end

  def name
    @snippet[/"Snippet (\S+)/,1]
  end
  def content
    content = @snippet
    sub_keys_regexp = "((#{@subs.keys.join('|')})(\.(#{@subs.keys.join('|')}))*)"
    content.gsub!(/\.?"((?:\\"|[^"])+)"\.(#{sub_keys_regexp})/) do |match|
      content_match = $1
      sub_match = $2
      sub_match.gsub!(/(st|et)\.?/) do |match|
        SUBS[@subs[$1]]
      end
      "#{content_match}#{sub_match}"
    end
    content[/Snippet \S+ (.*?)"?$/,1]
  end
end
