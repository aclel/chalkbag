require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:climbs) }  
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) } 
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:follows) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "climb associations" do

    before { @user.save }
    let!(:older_climb) do
      FactoryGirl.create(:climb, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_climb) do
      FactoryGirl.create(:climb, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right climbs in the right order" do
      expect(@user.climbs.to_a).to eq [newer_climb, older_climb]
    end

    it "should destroy associated climbs" do
      climbs = @user.climbs.to_a
      @user.destroy
      expect(climbs).not_to be_empty
      climbs.each do |climb|
        expect(Climb.where(id: climb.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:climb, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_climb) }
      its(:feed) { should include(older_climb) }
      its(:feed) { should_not include(unfollowed_post) }
    end

    describe "following" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        @user.save
        @user.follow!(other_user)
      end
      it { should be_following(other_user) }
      its(:followed_users) { should include(other_user) }

      describe "followed user" do
        subject { other_user }
        its(:follows) { should include(@user) }
      end

      describe "and unfollowing" do
        before { @user.unfollow!(other_user) }

        it { should_not be_following(other_user) }
        its(:followed_users) { should_not include(other_user) }
      end
    end
  end
  
  describe "climb associations" do
    before { @user.save }
    let!(:older_climb) do
      FactoryGirl.create(:climb, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_climb) do
      FactoryGirl.create(:climb, user: @user, created_at: 1.hour.ago)
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:climb, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.climbs.create!(content: "Lorem ipsum", grade: 20) }
      end

      its(:feed) { should include(newer_climb) }
      its(:feed) { should include(older_climb) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.climbs.each do |climb|
          should include(climb)
        end
      end
    end
  end
end
