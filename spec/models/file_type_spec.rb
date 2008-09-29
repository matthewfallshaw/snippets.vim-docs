require File.dirname(__FILE__) + '/../spec_helper'

describe FileType do
  before do
    FileType.send(:class_variable_set, :@@vimdir, File.join(File.dirname(__FILE__), "../fixtures/vimdir"))
  end
  after do
    FileUtils.rm(Dir[File.join(File.dirname(__FILE__), "../fixtures/vimdir/after/ftplugin/*")])
  end
  describe "class methods" do
    it "should discover contents of after/ftplugin directory" do
debugger
      %w[html rails ruby xhtml].each do |ft|
        create_snippets_file(ft)
      end
      FileType.all.collect(&:name).should == %w[html rails ruby xhtml]
    end
  end
  it "should require a file on initialization" do
    lambda { FileType.new }.should raise_error(ArgumentError)
    lambda { FileType.new("filetype") }.should_not raise_error(ArgumentError)
  end
  describe '#name' do
    it "should respond with the filetype part of the file basename" do
      FileType.new("this/thing_snippets.vim").name.should == "thing"
    end
  end
  describe "#snippets" do
    it "should be a collection of snippets" do
      create_snippets_file("ruby") do |f|
        f.puts <<-TEXT
if !exists('loaded_snippet') || &cp
    finish
endif

let st = g:snip_start_tag
let et = g:snip_end_tag
let cd = g:snip_elem_delim

exec "Snippet mrnt rename_table \"".st."oldTableName".et."\", \"".st."newTableName".et."\"".st.et
exec "Snippet rfu render :file => \"".st."filepath".et."\", :use_full_path => ".st."false".et.st.et
        TEXT
      end
      FileType.new("after/ftplugin/ruby_snippets.vim").snippets.size.should == 2
    end
  end

  private

  def create_snippets_file(file_type)
    file = File.join(File.dirname(__FILE__), "../fixtures/vimdir/after/ftplugin", "#{file_type}_snippets.vim")
    FileUtils.touch(file)
    File.open(file, 'w') do |f|
      yield f if block_given?
    end
  end
end
