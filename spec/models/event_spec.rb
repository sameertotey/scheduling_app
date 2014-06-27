require 'spec_helper'

describe Event do
  it { should belong_to(:user) }

  it { should belong_to(:event_type) }

  context "get_events_for_range" do
    before :each do
      @event = FactoryGirl.create(:event)
      @range = Date.new(2014,8, 1)..Date.new(2014, 8, -1)
    end
    it "finds event in the middle of the range" do
      @event.date = Date.new(2014, 8, 15)
      @event.save
      expect(Event.get_events_for_range(@range).count).to eq 1
      expect(Event.get_events_for_range(@range)).to eq [@event]
    end
    it "finds event at the begining of the range" do
      @event.date = Date.new(2014, 8, 1)
      @event.save
      expect(Event.get_events_for_range(@range).count).to eq 1
      expect(Event.get_events_for_range(@range)).to eq [@event]
    end
    it "finds event at the end of the range" do
      @event.date = Date.new(2014, 8, 31)
      @event.save
      expect(Event.get_events_for_range(@range).count).to eq 1
      expect(Event.get_events_for_range(@range)).to eq [@event]
    end
    it "does not find events outside the range" do
      @event.date = Date.new(2014, 7, 31)
      @event.save
      expect(Event.get_events_for_range(@range).count).to eq 0
      expect(Event.get_events_for_range(@range)).to eq []
    end
    it "finds multiple events within the range" do
      @event.date = Date.new(2014, 8, 1)
      @event.save
      event2 = FactoryGirl.create(:event)
      event2.date = Date.new(2014, 8, 2)
      event2.save
      expect(Event.get_events_for_range(@range).count).to eq 2
      expect(Event.get_events_for_range(@range)).to eq [@event, event2]
    end

  end
end
