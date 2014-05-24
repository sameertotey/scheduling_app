require 'spec_helper'

describe Identity, :type => :model do

  before(:each){ @identity = Identity.new(uid: 'user1', provider: 'provider1')}

  it "is valid with a uid, and provider" do
    identity = Identity.new(
      uid: 'user1',
      provider: 'provider')
    expect(identity).to be_valid 
  end  

  it { should belong_to(:user) }

  it { should respond_to(:name) }

  it { should respond_to(:user) }

  it { should validate_uniqueness_of(:uid).scoped_to(:provider) }

end
