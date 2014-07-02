class Holiday < ActiveRecord::Base
  def self.all_holidays_for_year(year)
    all.map do |holiday|
      parse_day(year, holiday.day_str)
    end
  end

  def self.first_wednesday_of_month(year, month)
    if month == Date.new(year, month).beginning_of_week.days_since(2).month
      date = Date.new(year, month).beginning_of_week.days_since(2)
    else
      date = Date.new(year, month).beginning_of_week.days_since(9)
    end
    date
  end

  def self.second_wednesday_of_month(year, month)
    first_wednesday_of_month(year, month).days_since(7)
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