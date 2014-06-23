require 'spec_helper'

describe User, :type => :model do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it { should respond_to(:identity) }
  
  it { should have_one(:identity) }

  it { should respond_to(:profile) }

  it { should respond_to(:admin) }

  it { should have_one(:profile) }

  it { should have_many(:events) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

  it "is invalid without password" do
    expect(@user).to_not be_valid
  end

  it "is invalid with short password" do
    @user.password = "pass"
    expect(@user).to have(1).errors_on(:password)
  end

  it "is valid with password" do
    @user.password = "password"
    expect(@user).to be_valid
  end

  it "sets up the depend models if not present" do
    expect(Identity.count).to eq 0
    expect(Profile.count).to eq 0
    @user.password = "password"
    @user.save
    expect(Identity.count).to eq 1
    expect(Profile.count).to eq 1
  end

end
