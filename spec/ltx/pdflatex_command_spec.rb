require 'spec_helper'
require 'open3'

require 'ltx/commands/pdflatex_command'

describe Ltx::Commands::PdflatexCommand do
	subject { Ltx::Commands::PdflatexCommand.new("document") }
	it "should require a document in the constructor" do
		document = double("document")
		cmd = Ltx::Commands::PdflatexCommand.new(document)
		cmd.document.should == document
	end

	it "is not possible for document to be nil" do
		expect { Ltx::Commands::PdflatexCommand.new(nil) }.to raise_error
	end

	it "should have a draft setting" do
		subject.draft?.should == false

		subject.draft
		subject.draft?.should == true

		subject.draft= false
		subject.draft?.should == false
	end

	it "should build arguments properly" do
		subject.stub(:parse_log).and_return(subject)
		subject.stub(:read_log)

		Open3.stub(:popen3)
		Open3.should_receive(:popen3) do |cmd, *args|
			args.should include "-draftmode"
			args.should include "document"
		end

		subject.draft
		subject.execute
	end

	it "should parse logs properly"
	it "should read logs properly"
end
