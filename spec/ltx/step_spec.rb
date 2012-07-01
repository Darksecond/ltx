require 'spec_helper'

require 'ltx/generators/step'

describe Ltx::Generators::Step do
	subject { Ltx::Generators::Step.new "document" }
	let(:latex) { double("command") }
	before do Ltx::Commands::PdflatexCommand.stub(:new).and_return{ latex } end

	it "should return a new correct step when running next_step" do
		latex.stub(:rerun_needed?)
		latex.stub(:execute)
		next_step = subject.next_step
		next_step.class.should == Ltx::Generators::Step
	end

	it "should run pdflatex when running next_step" do
		latex.should_receive(:execute)
		latex.stub(:rerun_needed?)
		subject.next_step
	end

	it "should track reruns" do
		subject.rerun?.should == true
		subject.rerun
		subject.rerun?.should == true
		subject.rerun
		subject.rerun?.should == true
	end

	#stuff about tracking
	it "should track a file on track"
	it "should return the file tracked on get_track"
	it "should for a next_step"

	#stuff about modules
	it "should run all modules on next_step"
	it "should run all modules after pdflatex"
end
