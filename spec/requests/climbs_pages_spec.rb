require 'spec_helper'

describe "Climb pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "climb creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a climb" do
        expect { click_button "Post" }.not_to change(Climb, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'climb_content', with: "Lorem ipsum" }
      before { fill_in 'climb_grade', with: 20}
      
      it "should create a climb" do
        expect { click_button "Post" }.to change(Climb, :count).by(1)
      end
    end
  end
  
  describe "climb destruction" do
    before { FactoryGirl.create(:climb, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a climb" do
        expect { click_link "delete" }.to change(Climb, :count).by(-1)
      end
    end
  end
end