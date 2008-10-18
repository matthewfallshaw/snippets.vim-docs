require File.dirname(__FILE__) + '/../spec_helper'

describe Snippet do
  describe "#new" do
    it "should require snippet" do
      lambda { Snippet.new }.should raise_error(ArgumentError) do |error|
        error.message.should match(/wrong number of arguments/)
      end
    end
    it "should record snippet" do
      Snippet.new("a snippet string").instance_variable_get(:@snippet).should == "a snippet string"
    end
    it "should assume {} if subs is not supplied" do
      s = Snippet.new(:file)
      s.instance_variable_get(:@subs).should == {}
    end
  end
  it "should extract name from snippet string" do
    snippet = Snippet.new('"Snippet mrnt rename_table…"')
    snippet.name.should == "mrnt"
  end
  it "should extract content from snippet string" do
    snippet = Snippet.new('"Snippet mrnt rename_table…"')
    snippet.content.should == "rename_table…"
  end
  it "should replace subs to build content" do
    subs = { "st" => "snip_start_tag",
             "et" => "snip_end_tag" }
    snippet = Snippet.new('"Snippet mrnt rename_table \"".st."oldTableName".et."\", \"".st."newTableName".et."\"".st.et', subs)
    snippet.content.should == <<-STR.chomp
rename_table \\"<{oldTableName}>\\", \\"<{newTableName}>\\"<{}>
      STR
  end
end

__END__
let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet mrnt rename_table \"".st."oldTableName".et."\", \"".st."newTableName".et."\"".st.et
exec "Snippet rfu render :file => \"".st."filepath".et."\", :use_full_path => ".st."false".et.st.et
