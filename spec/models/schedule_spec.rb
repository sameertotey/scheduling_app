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
    it "does not return non info events" do
      user = FactoryGirl.create(:user)
      holiday = FactoryGirl.create(:holiday, day_str: "07-04")
      app_setting = AppSetting.create({num_docs_friday: 1,
       max_num_full_days: 2,
      max_initial_shifts: 5,
      friday_full_shift: true})
      expect(Schedule.make_events(2014, 7, user)).to eq []
      p Event.count
    end


  end

end
