class Schedule

  def self.get_events(year, month)
    range = Date.new(year.to_i,month.to_i, 1)..Date.new(year.to_i, month.to_i, -1)
    events = Event.get_events_for_range(range).select do |event|
      event.event_type.name == "info"
    end
  end

  def self.make_events(year, month, current_user)
    range = Date.new(year.to_i,month.to_i, 1)..Date.new(year.to_i, month.to_i, -1)
    date = Date.new(year.to_i, month.to_i).beginning_of_month
    event_type = EventType.find_or_create_by(name: "info")
    range.each do |date|
      puts "days to start of week #{date.days_to_week_start}"
      if date.days_to_week_start < 4
        create_four_day_events(date, event_type, current_user)
      elsif date.days_to_week_start == 4
        puts "Friday"
      elsif date.days_to_week_start == 5
        puts "Saturday"
      end
          
    end
    []
  end

  private

  def self.create_four_day_events(date, event_type, current_user)
    (1..2).each do |shift|
      (1..2).each do |num|
        event = Event.find_or_create_by({date: date, shift: shift, comment: "Dr#{num}", event_type: event_type, user: current_user})
      end
    end 
  end
end