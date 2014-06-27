class Holiday < ActiveRecord::Base
  def self.all_holidays_for_year(year)
    holidays = []
    all.each do |holiday|
      holidays << parse_day(year, holiday.day_str)
    end
    holidays
  end

  private

  def self.parse_day(year, day_str)
    if (m = day_str.match /\A(\d\d)-(\d\d)\z/)
      date = Date.new(year, m[1].to_i, m[2].to_i)
    elsif (m = day_str.match /\A(\d\d)-W(-|\+)(\d)-(\d)\z/)
      month = m[1].to_i
      day = m[4].to_i
      if m[2] == "-" 
        # only last week is needed with -1, other values are ignored
        if month == Date.new(year, month + 1).beginning_of_week.month
          date = Date.new(year, month + 1).beginning_of_week
        else
          date = Date.new(year, month + 1).beginning_of_week.days_ago(7)
        end
      else
        week = m[3].to_i
        if month == Date.new(year, month).beginning_of_week.days_since(day).month
          date = Date.new(year, month).beginning_of_week.days_since(day + ((week - 1) * 7))
        else
          date = Date.new(year, month).beginning_of_week.days_since(day + (week * 7))
        end          
      end
    else  
      raise "Holiday: The date string could not be parsed"      
    end
    date
  end
end