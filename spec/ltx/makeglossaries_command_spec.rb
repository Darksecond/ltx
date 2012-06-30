require 'spec_helper'
require 'open3'

require 'ltx/commands/makeglossaries_command'

describe Ltx::Commands::MakeglossariesCommand do
	subject { Ltx::Commands::MakeglossariesCommand.new "document" }
	it "should not be possible for document to be nil" do
		expect { Ltx::Commands::MakeglossariesCommand.new(nil) }.to raise_error
	end

	it "should require a document in the constructor" do
		document = double("document")
		cmd = Ltx::Commands::MakeglossariesCommand.new(document)
		cmd.document.should == document
	end

	it "should build arguments" do
		Open3.stub(:popen3)
		Open3.should_receive(:popen3) do |cmd, *args|
			args.should include "-q"
			args.should include "document"
		end

		subject.execute
	end

	it "should execute" do
		Open3.stub(:popen3)
		Open3.should_receive(:popen3)

		subject.execute
	end
end
