class Schedule

  def self.get_events(year, month)
    range = Date.new(year.to_i,month.to_i, 1)..Date.new(year.to_i, month.to_i, -1)
    events = Event.get_events_for_range(range).select do |event|
      event.event_type.name == "info"
    end
  end

  def self.make_events(year, month)
    range = Date.new(year.to_i,month.to_i, 1)..Date.new(year.to_i, month.to_i, -1)
    holidays = Holiday.all_holidays_for_year(year).select do |holiday|
      holiday.month == month
    end
    event_type = EventType.find_or_create_by(name: "info")
    range.each do |date|
      unless holidays.any? {|holiday| holiday == date}
        if date.days_to_week_start < 4
          create_four_day_events(date, event_type)
        elsif date.days_to_week_start == 4
          create_friday_events(date, event_type)
        elsif date.days_to_week_start == 5
          create_saturday_events(date, event_type)
        end
      end
    end
    get_events(year, month)
  end

  def self.make_assignment(year, month)
      # assignees = Profile.with_role(role)
      assignees = User.all
      range = Date.new(year.to_i,month.to_i, 1)..Date.new(year.to_i, month.to_i, -1)
      Event.get_events_range_type(range, "yes").each do |event|
        assign_yes_to_slot(event)
      end
      assign_wednesdays(year, month)
      if AppSetting.first.num_docs_friday == 1
        assign_fridays(year, month)
      end
      assign_saturdays(year, month)
      assign_full_days(range)
      assign_remainder

  end

  private

  def self.create_four_day_events(date, event_type)
    (1..2).each do |shift|
      (1..2).each do |num|
        event = Event.find_or_create_by({date: date, shift: shift, 
          comment: "Dr#{num}", event_type: event_type})
      end
    end 
  end

  def self.create_friday_events(date, event_type)
    (1..2).each do |shift|
      (1..AppSetting.first.num_docs_friday).each do |num|
        event = Event.find_or_create_by({date: date, shift: shift, 
          comment: "Dr#{num}", event_type: event_type})
      end
    end 
  end

  def self.create_saturday_events(date, event_type)
    (1..1).each do |shift|
      (1..2).each do |num|
        event = Event.find_or_create_by({date: date, shift: shift, 
          comment: "Dr#{num}", event_type: event_type})
      end
    end 
  end

  def self.assign_wednesdays(year, month)
    date = Holiday.first_wednesday_of_month(year, month)
    assign_round_robin_for_date(date)
    date = Holiday.second_wednesday_of_month(year, month)
    assign_round_robin_for_date(date)
  end

  def self.assign_fridays(year, month)
    dates = Holiday.all_fridays_of_month(year, month)
    assignees = get_assignees
    return if assignees.empty?
    users = assignees.shuffle.cycle
    dates.each do |date|
      events = Event.get_events_range_type(date, "info").to_a
      events.each do |event|
        attempts = 1
        until event.assigned? || attempts > assignees.count
          event.user = nil unless Event.assign_user(event, users.next)
          attempts += 1
        end
      end    
    end
  end

  def self.assign_saturdays(year, month)
    dates = Holiday.all_saturdays_of_month(year, month)
    assignees = get_assignees
    return if assignees.empty?
    users = assignees.shuffle.cycle
    dates.each do |date|
      events = Event.get_events_range_type(date, "info").to_a
      events.each do |event|
        attempts = 1
        until event.assigned? || attempts > assignees.count
          event.user = nil unless Event.assign_user(event, users.next)
          attempts += 1
        end
      end    
    end
  end

  def self.assign_full_days(range)
    assignees = get_assignees
    return if assignees.empty?
    users = assignees.shuffle.cycle
    range.each do |date|
      events = Event.get_events_range_type(date, "info").unassigned.to_a
      event_shift1, event_shift2 = events.partition {|event| event.shift == 1}
      p event_shift1, event_shift2
      unless (event_shift1.empty? || event_shift2.empty?)
        Event.assign_user_to_list([event_shift1.first, event_shift2.first], users.next)
      end
    end    
  end

  def self.assign_round_robin_for_date(date)
    assignees = get_assignees
    return if assignees.empty?
    users = assignees.shuffle.cycle
    events = Event.get_events_range_type(date, "info").to_a
    events.each do |event|
      attempts = 1
      until event.assigned? || attempts > assignees.count
        event.user = nil unless Event.assign_user(event, users.next)
        attempts += 1
      end
    end
  end

  def self.get_assignees
    User.all
  end

  def self.assign_yes_to_slot(event)
    event_type = EventType.find_by(name: "info")
    (1..2).each do |num|
      unless Event.exists?(user: event.user, date: event.date, shift: event.shift, event_type: event_type)
        if event_info = Event.find_by(date: event.date, shift: event.shift, event_type: event_type, comment: "Dr#{num}")
          if event_info.unassigned?
            Event.assign_user(event_info, event.user)
          end
        end
      end
    end
  end

end