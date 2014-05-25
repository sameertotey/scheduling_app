require 'spec_helper'

describe Profile do
  it { should belong_to(:user) }

  it { should respond_to(:first_name) }

  it { should respond_to(:user) }

end
