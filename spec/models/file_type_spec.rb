require File.dirname(__FILE__) + '/../spec_helper'

describe FileType do
  before do
    FileType.send(:class_variable_set, :@@vimdir, fixtures_dir)
  end
  after do
    FileUtils.rm(Dir[File.join(fixtures_dir, "after/ftplugin/*")])
  end

  describe "class methods" do
    it "should discover contents of after/ftplugin directory" do
      %w[html rails ruby xhtml].each do |ft|
        create_filetype_fixture(ft)
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
    before do
      @file = create_filetype_fixture("ruby") do |f|
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
    end
    it "should be a collection of snippets" do
      FileType.new(@file).snippets.size.should == 2
      Snippet.stub!(:new).and_return(mock("snippet"))
    end
    it "should extract subs" do
      subs = { "st" => "snip_start_tag",
               "et" => "snip_end_tag",
               "cd" => "snip_elem_delim" }
      Snippet.should_receive(:new).exactly(2).times.with(an_instance_of(String), subs)
      FileType.new(@file).snippets
    end
  end

  private

  def fixtures_dir
    File.expand_path(File.join(File.dirname(__FILE__), "../fixtures/vimdir"))
  end

  def create_filetype_fixture(file_type)
    file = File.join(fixtures_dir, "after/ftplugin", "#{file_type}_snippets.vim")
    FileUtils.mkdir_p(File.dirname(file))
    FileUtils.touch(file)
    File.open(file, 'w') do |f|
      yield f if block_given?
    end
    file
  end
end
