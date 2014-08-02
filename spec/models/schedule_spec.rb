require 'spec_helper'

describe Schedule do
  def create_four_assignees
    (1..4).each do
      user1 = FactoryGirl.create(:user)
      FactoryGirl.create(:profile, user: user1, role: 'assignee')
    end
  end

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

    before :each do
      holidays = Holiday.create([
        {day_str: '01-01', description: 'January 1st, New years day'},
        {day_str: '05-W-1-0', description: 'Last Monday of May, Memorial day'},
        {day_str: '07-04', description: 'July 4th, Independence day'},
        {day_str: '09-W+1-0', description: 'First Monday of September, Labor day'},
        {day_str: '11-W+4-3', description: 'Fourth Thursday in November, Thanksgiving day'},
        {day_str: '12-24', description: 'December 24, Christmas eve'},
        {day_str: '12-25', description: 'December 25, Christmas day'}
                                ])
      app_setting = AppSetting.create({num_docs_friday: 1,
        max_num_full_days: 2,
        max_initial_shifts: 5,
        friday_full_shift: true})
    end
    it "makes all events for a month" do
      Schedule.make_events(2014, 7)
      expect(Event.all.count).to eq 90
    end
    it 'makes all events for another month' do
      Schedule.make_events(2014, 8)
      expect(Event.count).to eq 84
      # expect(Schedule.make_events(2014, 9).count).to eq 84
      # expect(Schedule.make_events(2014, 10).count).to eq 90
      # expect(Schedule.make_events(2014, 11).count).to eq 78
      # expect(Schedule.make_events(2014, 12).count).to eq 84
      # expect(Schedule.make_events(2014, 6).count).to eq 84
      # expect(Schedule.make_events(2014, 5).count).to eq 84
    end

  end

  context "assign_yes_to_slot" do
    it "attempts to assign a yes request to a user whenever possible" do
      allow(Event).to receive(:assign_user)
      user = FactoryGirl.create(:user)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event_yes_assigned = FactoryGirl.create(:event, date: Date.new(2014,7,3), shift: 1, user: user, event_type: event_type_yes)
      event_info_unassigned = FactoryGirl.create(:event, date: Date.new(2014,7,3), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      Schedule.assign_yes_to_slot(event_yes_assigned)
      expect(Event).to have_received(:assign_user).with(event_info_unassigned, user)
    end

    it "assigns a yes request to a user whenever possible" do
      allow(Event).to receive(:assign_user).and_call_original
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event_yes_assigned1 = FactoryGirl.create(:event, date: Date.new(2014, 7, 3), shift: 1, user: user1, event_type: event_type_yes)
      event_yes_assigned2 = FactoryGirl.create(:event, date: Date.new(2014, 7, 3), shift: 1, user: user2, event_type: event_type_yes)
      event_yes_assigned3 = FactoryGirl.create(:event, date: Date.new(2014, 7, 3), shift: 1, user: user3, event_type: event_type_yes)
      event_info_unassigned1 = FactoryGirl.create(:event, date: Date.new(2014, 7, 3), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event_info_unassigned2 = FactoryGirl.create(:event, date: Date.new(2014, 7, 3), shift: 1, comment: "Dr2", user: nil, event_type: event_type_info)
      Schedule.assign_yes_to_slot(event_yes_assigned1)
      Schedule.assign_yes_to_slot(event_yes_assigned2)
      Schedule.assign_yes_to_slot(event_yes_assigned3)
      expect(Event).to have_received(:assign_user).twice
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
      expect(Schedule).to have_received(:assign_full_days).at_least(:once)
      expect(Schedule).to have_received(:assign_remainder)
    end
  end

  context "assign_wednesdays" do
    before :each do
      create_four_assignees
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
      FactoryGirl.create(:event, date: Date.new(2014, 7, 2), shift: 1, user: User.first, event_type: event_type_no)
      FactoryGirl.create(:event, date: Date.new(2014, 7, 2), shift: 1, user: User.first, event_type: event_type_no)
      FactoryGirl.create(:event, date: Date.new(2014, 7, 2), shift: 2, user: User.first, event_type: event_type_no)
      FactoryGirl.create(:event, date: Date.new(2014, 7, 2), shift: 2, user: User.first, event_type: event_type_no)

      Schedule.assign_round_robin_for_date(Date.new(2014,7,2))
      expect(Event.unassigned.count).to eq 0
      expect(User.first.events.count).to eq 4
    end
  end

  context "assign_fridays" do
    before :each do
      create_four_assignees
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,11), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,18), shift: 2, comment: "Dr1", user: nil, event_type: event_type_info)
      event3 = FactoryGirl.create(:event, date: Date.new(2014,7,11), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event4 = FactoryGirl.create(:event, date: Date.new(2014,7,18), shift: 2, comment: "Dr1", user: nil, event_type: event_type_info)

    end

    it "assigns events for a date to all users expect user who has declined the shifts" do
      expect(Event.unassigned.count).to eq 4
      Schedule.assign_fridays(2014, 7)
      expect(Event.unassigned.count).to eq 0
    end
  end

  context "assign_saturdays" do
    before :each do
      create_four_assignees
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,12), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event4 = FactoryGirl.create(:event, date: Date.new(2014,7,12), shift: 1, comment: "Dr2", user: nil, event_type: event_type_info)

    end

    it "assigns events for a date to all users expect user who has declined the shifts" do
      expect(Event.unassigned.count).to eq 2
      Schedule.assign_saturdays(2014, 7)
      expect(Event.unassigned.count).to eq 0
    end
  end

  context "assign_remainder" do
    before :each do
      create_four_assignees
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,15), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,15), shift: 2, comment: "Dr2", user: nil, event_type: event_type_info)

    end

    it "assigns events for a date to all users expect user who has declined the shifts" do
      expect(Event.unassigned.count).to eq 2
      Schedule.assign_remainder(Date.new(2014, 7, 1)..Date.new(2014, 7, -1))
      expect(Event.unassigned.count).to eq 0
    end
  end

  context "assign_full_days" do
    it "calls assign_round_robin_for_date" do
      create_four_assignees
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_yes = FactoryGirl.create(:event_type, name: "yes")
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr2", user: nil, event_type: event_type_info)
      event3 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr1", user: nil, event_type: event_type_info)
      event4 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr2", user: nil, event_type: event_type_info)
      expect(Event.unassigned.count).to eq 4
      Schedule.assign_full_days(Date.new(2014,7,2)..Date.new(2014,7,2))
      expect(Event.unassigned.count).to eq 2
    end

    it "fails the full transaction if any shift has error" do
      user = FactoryGirl.create(:user)
      event_type_info = FactoryGirl.create(:event_type, name: "info")
      event_type_no = FactoryGirl.create(:event_type, name: "no")      
      event1 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 1, comment: "Dr1", user: nil, event_type: event_type_info)
      event2 = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr1", user: nil, event_type: event_type_info)
      event2_no = FactoryGirl.create(:event, date: Date.new(2014,7,2), shift: 2, comment: "Dr1", user: user, event_type: event_type_no)

      expect(Event.unassigned.count).to eq 2
      Schedule.assign_full_days(Date.new(2014,7,2)..Date.new(2014,7,2))
      expect(Event.unassigned.count).to eq 2
    end
  end

  context "get_assignees" do
    before :each do
      @user1 = FactoryGirl.create(:user)
      @profile1 = FactoryGirl.create(:profile, user: @user1, role: 'assignee')
    end

    it "returns correct assignee" do
      expect(Schedule.get_assignees.count).to eq 1
      expect(Schedule.get_assignees).to eq [@user1]
    end
    it "does not return in-correct assignee" do
      @profile1.role = 'role'
      @profile1.save
      expect(Schedule.get_assignees.count).to eq 0
    end

    it "returns multiple assignees" do
      user2 = FactoryGirl.create(:user)
      profile2 = FactoryGirl.create(:profile, user: user2, role: 'assignee')

      expect(Schedule.get_assignees.count).to eq 2
      expect(Schedule.get_assignees).to eq [@user1, user2]
    end
  end

  context :sort_assignees_for_range do
    before :each do
      create_four_assignees
      @assignees = Schedule.get_assignees
      @range = Date.new(2014, 7, 1)..Date.new(2014, 7, -1)
    end

    it 'returns array of assignee if there are not events assigned' do
      expect(Schedule.sort_assignee_for_range(@assignees, @range).count).to eq 4
      end

    it 'returns array sorted according to the number of events assigned' do
      allow(Event).to receive(:count_for_user_in_range).and_return(4, 1, 2, 7)
      sorted = Schedule.sort_assignee_for_range(@assignees, @range)
      expect(sorted[0]).to eq @assignees[1]
      expect(sorted[1]).to eq @assignees[2]
      expect(sorted[2]).to eq @assignees[0]
      expect(sorted[3]).to eq @assignees[3]
    end
  end

  context 'clean assignments' do
    before :each do

    end
  end
end
