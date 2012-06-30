require 'spec_helper'

require 'ltx/modules/makeglossaries_module'

describe Ltx::Modules::MakeglossariesModule do
	subject { Ltx::Modules::MakeglossariesModule.new "document" }
	let(:step) { double "step" }
	before do
		Ltx::Commands::MakeglossariesCommand.stub(:execute).and_return true
	end

	it "should start tracking glo files on start_chain" do
		step.should_receive(:track).with("document.glo")
		subject.start_chain step
	end

	it "should compile when the gls file is missing" do
		File.stub(:exists?).and_return(false)
		Ltx::Commands::MakeglossariesCommand.any_instance.should_receive(:execute)
		subject.post_compile step
	end

	it "should compile when the glo file became different between runs" do
		prev = {}
		curr = {}
		prev[:checksum] = 1
		curr[:checksum] = 2
		prev_step = double "previous"
		prev_step.stub(:get_track).and_return prev

		step.stub(:previous).and_return(prev_step)
		step.stub(:get_track).and_return curr

		File.stub(:exists?).and_return(true)
		Ltx::Commands::MakeglossariesCommand.any_instance.should_receive(:execute)
		subject.post_compile step
	end

	it "should not compile when the glo file stayed the same" do
		prev = {}
		curr = {}
		prev[:checksum] = 1
		curr[:checksum] = 1
		prev_step = double "previous"
		prev_step.stub(:get_track).and_return prev

		step.stub(:previous).and_return(prev_step)
		step.stub(:get_track).and_return curr

		File.stub(:exists?).and_return(true)
		Ltx::Commands::MakeglossariesCommand.any_instance.should_not_receive(:execute)
		subject.post_compile step
	end
end
