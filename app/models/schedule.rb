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

  def self.make_assignment(year, month, role)
      assignees = Profile.with_role(role)
      p assignees
      get_events(year, month).each do |event|
        if event.unassigned?
          assign(event)
        end
      end
      assignees.first.user
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

  def self.assign_user(event, user)
    event.user = user
    event.save
    event
  end

  def self.assign(event)
  end
end