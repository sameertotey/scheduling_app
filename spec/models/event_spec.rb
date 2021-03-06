require 'spec_helper'

describe Event do
  it { should belong_to(:user) }

  it { should belong_to(:event_type) }

  context 'unassigned?' do
    it 'reports assigned status' do
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
      eve = Event.get_events_range_type(@range, "info")
      expect(Event.get_events_range_type(@range, "info").count).to eq 1
      expect(Event.get_events_range_type(@range, "info")).to eq [@event]
    end
    it 'does not find events with incorrect type' do
      @event.date = Date.new(2014, 8, 15)
      @event.event_type = @event_type
      @event.save
      expect(Event.get_events_range_type(@range, "no").count).to eq 0
      expect(Event.get_events_range_type(@range, "no")).to eq []
    end
  end

  context 'count_for_user_in_range' do
    before :each do
      @user = FactoryGirl.create(:user)
      @event = FactoryGirl.create(:event)
      @range = Date.new(2014, 8, 1)..Date.new(2014, 8, -1)
      @event_type = FactoryGirl.create(:event_type, name: "info")
    end

    it 'does not count events that are not initialized' do
      expect(Event.count_for_user_in_range(@user, @range)).to eq 0
    end

    it 'does not count events that are not assigned' do
      @event.date = Date.new(2014, 8, 15)
      @event.event_type = @event_type
      expect(Event.count_for_user_in_range(@user, @range)).to eq 0
    end

    it 'does not count events not of info type' do
      @event.date = Date.new(2014, 8, 15)
      @event.user = @user
      @event.save
      expect(Event.count_for_user_in_range(@user, @range)).to eq 0
    end

    it 'counts event in the middle of the range with correct type' do
      @event.date = Date.new(2014, 8, 15)
      @event.event_type = @event_type
      @event.user = @user
      @event.save
      expect(Event.count_for_user_in_range(@user, @range)).to eq 1
    end
  end

  context "conflicting_event_types" do
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

  context "conflicting_shifts" do
    before :each do
      @event_type_info = FactoryGirl.create(:event_type, name: "info")
      @user = FactoryGirl.create(:user)
    end

    it "finds yes-no conflict events" do
      event1 = FactoryGirl.create(:event, user: @user, shift: 1, date: Date.new(2014, 7, 3), event_type: @event_type_info)
      event2 = FactoryGirl.build(:event, user: @user, shift: 1, date: Date.new(2014, 7, 3), event_type: @event_type_info)
      expect(event2).to have(1).errors_on(:shift)
    end
  end

  context "assign users to events" do
    it "updates info event to other user" do
      user1 = FactoryGirl.create(:user)
      event_type = FactoryGirl.create(:event_type, name: "info")
      event = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: nil, event_type: event_type)
      expect(Event.assign_user(event, user1)).to be true
      expect(Event.find(event.id).user).to eq user1
    end

    it "returns failure if validations fail" do
      user1 = FactoryGirl.create(:user)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_no = FactoryGirl.create(:event_type, name: "no")
      event_no = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: user1, event_type: event_type_no)
      event_info = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: nil, event_type: event_type_info)
      expect(Event.assign_user(event_info, user1)).to be false
      expect(Event.find(event_info.id).user).to eq nil
    end
  end

  context "assign users to list of events" do
    it "updates info event to given user" do
      user1 = FactoryGirl.create(:user)
      event_type = FactoryGirl.create(:event_type, name: "info")
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: nil, shift: 1, event_type: event_type)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: nil, shift: 2, event_type: event_type)
      Event.assign_user_to_list([event1, event2], user1)
      expect(Event.find(event1.id).user).to eq user1
      expect(Event.find(event2.id).user).to eq user1
    end

    it "fails transaction if validations fail" do
      user1 = FactoryGirl.create(:user)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_no = FactoryGirl.create(:event_type, name: "no")
      event_no = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: user1, event_type: event_type_no)
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: nil, shift: 1, event_type: event_type_info)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: nil, shift: 2, event_type: event_type_info)
      expect{Event.assign_user_to_list([event1, event2], user1)}.to raise_exception
      expect(Event.find(event1.id).user).to eq nil
    end
  end

end
