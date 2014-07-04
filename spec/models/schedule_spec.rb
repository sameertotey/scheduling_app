require 'spec_helper'

describe Schedule do
  context "get_events" do
    it "does not return non info events" do
      event = FactoryGirl.create(:event)
      event.date = Date.new(2014, 8, 15)
      event.save
      expect(Schedule.get_events(2014, 8)).to eq []
    end

    it "returns info events for a specific month" do
      event_type = FactoryGirl.create(:event_type)
      event_type.name = "info"
      event_type.save
      event = FactoryGirl.create(:event)
      event.date = Date.new(2014, 8, 15)
      event.event_type = event_type
      event.save
      expect(Schedule.get_events(2014, 8)).to eq [event]
    end

  end

  context "make_events" do
    it "makes events for a day" do
      date = Date.new(2014, 7, 3)
      event_type = FactoryGirl.create(:event_type, name: "info")
      Schedule.create_four_day_events(date, event_type)
      expect(Event.count).to eq 4
      expect(Event.first.user_id).to eq(nil)
    end

    it "does not return non info events" do
      holidays = Holiday.create([
        {day_str: '01-01', description: 'January 1st, New years day'},
        {day_str: '05-W-1-0', description: 'Last Monday of May, Memorial day'},
        {day_str: '07-04', description: 'July 4th, Inddependce day'},
        {day_str: '09-W+1-0', description: 'First Monday of September, Labor day'},
        {day_str: '11-W+4-3', description: 'Fourth Thursday in November, Thanksgiving day'},
        {day_str: '12-24', description: 'December 24, Christmas eve'},
        {day_str: '12-25', description: 'December 25, Christmas day'}
        ])  
      app_setting = AppSetting.create({num_docs_friday: 1,
        max_num_full_days: 2,
        max_initial_shifts: 5,
        friday_full_shift: true})
      expect(Schedule.make_events(2014, 7).count).to eq 90
      expect(Schedule.make_events(2014, 8).count).to eq 84
      expect(Schedule.make_events(2014, 9).count).to eq 84
      expect(Schedule.make_events(2014, 10).count).to eq 90
      expect(Schedule.make_events(2014, 11).count).to eq 78
      expect(Schedule.make_events(2014, 12).count).to eq 84
      expect(Schedule.make_events(2014, 6).count).to eq 84
      expect(Schedule.make_events(2014, 5).count).to eq 84 
    end

  end

  context "assign_yes_to_slot" do
    it "assigns a yes request to a user whenever possible" do
      allow(Event).to receive(:assign_user)
      user = FactoryGirl.create(:user)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event_yes_assigned = FactoryGirl.create(:event, date: Date.new(2014,7,3), shift: 1, user: user, event_type: event_type_yes)
      event_info_unassigned = FactoryGirl.create(:event, date: Date.new(2014,7,3), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      Schedule.assign_yes_to_slot(event_yes_assigned)
      expect(Event).to have_received(:assign_user)      
    end
  end

  context "make_assignment" do
    it "calls all the steps" do
      user = FactoryGirl.create(:user)
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event_yes_assigned = FactoryGirl.create(:event, date: Date.new(2014,7,3), shift: 1, user: user, event_type: event_type_yes)
      app_setting = AppSetting.create({num_docs_friday: 1,
        max_num_full_days: 2,
        max_initial_shifts: 5,
        friday_full_shift: true})

      allow(Schedule).to receive(:assign_yes_to_slot)
      allow(Schedule).to receive(:assign_fridays)
      allow(Schedule).to receive(:assign_saturdays)
      allow(Schedule).to receive(:assign_wednesdays)
      allow(Schedule).to receive(:assign_full_days)
      allow(Schedule).to receive(:assign_remainder)
      Schedule.make_assignment(2014, 7)
      expect(Schedule).to have_received(:assign_yes_to_slot)
      expect(Schedule).to have_received(:assign_fridays)
      expect(Schedule).to have_received(:assign_saturdays)
      expect(Schedule).to have_received(:assign_wednesdays)
      expect(Schedule).to have_received(:assign_full_days)
      expect(Schedule).to have_received(:assign_remainder)
    end
  end

  context "assign_wednesdays" do
    before :each do
      users = FactoryGirl.create_list(:user, 4)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr2", user: nil, event_type: event_type_info)
      event3 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr1", user: nil, event_type: event_type_info)
      event4 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr2", user: nil, event_type: event_type_info)

    end
    it "calls assign_round_robin_for_date" do
      allow(Schedule).to receive(:assign_round_robin_for_date)
      Schedule.assign_wednesdays(2014,7)
      expect(Schedule).to have_received(:assign_round_robin_for_date).twice
    end

    it "assigns events for a date to all users" do
      expect(Event.unassigned.count).to eq 4
      Schedule.assign_round_robin_for_date(Date.new(2014,7,2))
      expect(Event.unassigned.count).to eq 0
      expect(Event.assigned.count).to eq 4
      expect(User.first.events.count).to eq 1
      expect(User.last.events.count).to eq 1
    end

    it "assigns events for a date to all users expect user who has declined the shifts" do
      expect(Event.unassigned.count).to eq 4
      event_type_no = FactoryGirl.create(:event_type, name: "no")
      FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr1", user: User.first, event_type: event_type_no)
      FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr2", user: User.first, event_type: event_type_no)
      FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr1", user: User.first, event_type: event_type_no)
      FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr2", user: User.first, event_type: event_type_no)

      Schedule.assign_round_robin_for_date(Date.new(2014,7,2))
      expect(Event.unassigned.count).to eq 0
      expect(User.first.events.count).to eq 4
    end
  end

  context "assign_full_days" do
    before :each do
      users = FactoryGirl.create_list(:user, 4)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr2", user: nil, event_type: event_type_info)
      event3 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr1", user: nil, event_type: event_type_info)
      event4 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr2", user: nil, event_type: event_type_info)

    end
    it "calls assign_round_robin_for_date" do
      expect(Event.unassigned.count).to eq 4
      Schedule.assign_full_days(Date.new(2014,7,2)..Date.new(2014,7,2))
      expect(Event.unassigned.count).to eq 2
      Schedule.assign_full_days(Date.new(2014,7,2)..Date.new(2014,7,2))
      expect(Event.unassigned.count).to eq 0
    end
  end

end
