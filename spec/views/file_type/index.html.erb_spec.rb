require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/file_type/index" do
  before(:each) do
    FileType.stub!(:all).and_return([mock("ruby_snippet", :name => "ruby", :snippets => [])])
    render 'file_type/index'
  end
  
  it "should render a table of contents" do
    response.should have_tag('a', %r[ruby])
  end
  it "should render a snippets table" do
    response.should have_tag('table#ruby')
  end
end
