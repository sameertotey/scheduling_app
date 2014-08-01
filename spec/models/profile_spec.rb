require 'spec_helper'

describe Profile do
  it { should belong_to(:user) }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:description) }
  it { should respond_to(:phone) }
  it { should respond_to(:location) }
  it { should respond_to(:urls) }
  it { should respond_to(:image_loc) }
  it { should respond_to(:role) }
  it { should respond_to(:initials) }
  it { should respond_to(:css_class) }

  it { should respond_to(:user) }

  describe "with role scope" do
    before :each do
      @profile1 = FactoryGirl.create(:profile)
    end

    it "finds the role with correct scope" do
      expect(Profile.with_role("role1")).to eq([])
      expect(Profile.with_role("role")).to eq([@profile1])
      @profile1.role = "role1"
      @profile1.save
      expect(Profile.with_role("role1")).to eq([@profile1])
    end
  end

end
