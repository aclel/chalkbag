require 'spec_helper'

describe Climb do

	let(:user) { FactoryGirl.create(:user) }
	before { @climb = user.climbs.build(content: "Fuckin' ripper", grade: 20) }
	

	subject { @climb }

	it { should respond_to(:content) }
	it { should respond_to(:grade) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should eq user}

	describe "when user_id is not present" do
		before { @climb.user_id = nil }
		it { should_not be_valid }
	end

	describe "with bank content" do
		before { @climb.content = "" }
		it { should_not be_valid }
	end

	describe "with content that is too long" do
		before { @climb.content = "a" * 141 }
		it { should_not be_valid }
	end

	describe "with grade that is too big" do
		before { @climb.grade = 39}
		it { should_not be_valid }
	end

	describe "with grade that is too small" do
		before { @climb.grade = 0 }
		it { should_not be_valid }
	end

	describe "with grade that is not an integer" do
		before { @climb.grade = 20.6 }
		it { should_not be_valid }
	end
end
