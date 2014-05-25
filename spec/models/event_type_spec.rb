require 'spec_helper'

describe EventType do
  before(:each) { @event_type = EventType.new(name: 'EventCode', description: "Event description") }

  subject { @event_type }

  it { should respond_to(:name) }

  it { should respond_to(:description) }

  it { should have_many(:events) }

end
