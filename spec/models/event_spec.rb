require 'spec_helper'

describe Event do
  it { should belong_to(:user) }

  it { should belong_to(:event_type) }

  context "unassigned?" do
    it "reports assigned status" do
      event = Event.new(user: nil)
      expect(event.unassigned?).to eq true
      expect(event.assigned?).to be_falsey
      event.user = FactoryGirl.create(:user)
      expect(event.unassigned?).to eq false
      expect(event.assigned?).to be_truthy   
    end
  end


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
      @event = FactoryGirl.create(:event)
      @range = Date.new(2014,8, 1)..Date.new(2014, 8, -1)
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
    it "works with single day range" do
      @event = FactoryGirl.create(:event, date: Date.new(2014,8,1))
      @range = Date.new(2014,8, 1)
      @event = FactoryGirl.create(:event)
      @range = Date.new(2014,8, 1)..Date.new(2014, 8, -1)
    end
  end

  context "get_events_range_type" do
    before :each do
      @event = FactoryGirl.create(:event)
      @range = Date.new(2014,8, 1)..Date.new(2014, 8, -1)
      @event_type = FactoryGirl.create(:event_type, name: "info")
    end
    it "finds event in the middle of the range with correct type" do
      @event.date = Date.new(2014, 8, 15)
      @event.event_type = @event_type
      @event.save
      p Event.count
      p Event.all
      p EventType.count
      p EventType.all
      eve = Event.get_events_range_type(@range, "info")
      p eve
      expect(Event.get_events_range_type(@range, "info").count).to eq 1
      expect(Event.get_events_range_type(@range, "info")).to eq [@event]
    end
    it "does not find events with incorrect type" do
      @event.date = Date.new(2014, 8, 15)
      @event.event_type = @event_type
      @event.save
      expect(Event.get_events_range_type(@range, "no").count).to eq 0
      expect(Event.get_events_range_type(@range, "no")).to eq []
    end
  end

  context "conflicting_events" do
    before :each do
      @event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      @event_type_no = FactoryGirl.create(:event_type, name: "no")
      @event_type_info = FactoryGirl.create(:event_type, name: "info")
      @user = FactoryGirl.create(:user)
    end

    it "finds yes-no conflict events" do
      event1 = FactoryGirl.create(:event, user: @user, event_type: @event_type_yes)
      event2 = FactoryGirl.build(:event, user: @user, event_type: @event_type_no)
      expect(event2).to have(1).errors_on(:event_type)
    end

    it "finds no-yes conflict events" do
      event1 = FactoryGirl.create(:event, user: @user, event_type: @event_type_no)
      event2 = FactoryGirl.build(:event, user: @user, event_type: @event_type_yes)
      expect(event2).to have(1).errors_on(:event_type)
    end
    it "finds no-info conflict events" do
      event1 = FactoryGirl.create(:event, user: @user, event_type: @event_type_no)
      event2 = FactoryGirl.build(:event, user: @user, event_type: @event_type_info)
      expect(event2).to have(1).errors_on(:event_type)
    end
  end
end
