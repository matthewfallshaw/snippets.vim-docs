require File.dirname(__FILE__) + '/../spec_helper'

describe Snippet do
  describe "#new" do
    it "should require file" do
      lambda { Snippet.new }.should raise_error(ArgumentError) do |error|
        error.message.should match(/wrong number of arguments/)
      end
    end
    it "should assume {} if subs is not supplied" do
      s = Snippet.new(:file)
      s.instance_variable_get(:@subs).should == {}
    end
    # when /let (..) = g:(\w+)/
    #   subs[$1] = $2
    # when /exec (.*)/
    #   snippets << Snippet.new($1, subs)
  end
end
