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

  context "assign info events" do
    it "updates info event to other user" do
      user1 = FactoryGirl.create(:user)
      event_type = FactoryGirl.create(:event_type, name: "info")
      event = FactoryGirl.create(:event, date: Date.new(2014,7,3), user: nil, event_type: event_type)
      expect(Schedule.assign_user(event, user1).user).to eq user1
    end

  end

end
