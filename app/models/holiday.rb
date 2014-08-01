class Holiday < ActiveRecord::Base
  def self.all_holidays_for_year(year)
    all.map do |holiday|
      parse_day(year, holiday.day_str)
    end
  end

  def self.first_wednesday_of_month(year, month)
    date = Date.new(year, month)
    date += (3 - date.wday) % 7
  end

  def self.second_wednesday_of_month(year, month)
    first_wednesday_of_month(year, month).days_since(7)
  end

  def self.all_fridays_of_month(year, month)
    date = Date.new(year, month)
    date += (5 - date.wday) % 7
    dates = []
    while date.month == month
      dates << date
      date += 7
    end
    dates
  end

  def self.all_saturdays_of_month(year, month)
    date = Date.new(year, month)
    date += (6 - date.wday) % 7
    dates = []
    while date.month == month
      dates << date
      date += 7
    end
    dates
  end

  private

  def self.parse_day(year, day_str)
    if (m = day_str.match /\A(\d\d)-(\d\d)\z/)
      date = Date.new(year, m[1].to_i, m[2].to_i)
    elsif (m = day_str.match /\A(\d\d)-W(-|\+)(\d)-(\d)\z/)
      date = parse_week_format(m, year)
    else
      raise "Holiday: The date string could not be parsed"
    end
    date
  end

  def self.parse_week_format(m, year)
    month = m[1].to_i
    day = m[4].to_i
    if m[2] == "-"
      # only last week is needed with -1, other negative values are ignored
      if month == Date.new(year, month + 1).beginning_of_week.month
        # currently we only support last monday of the month
        date = Date.new(year, month + 1).beginning_of_week
      else
        date = Date.new(year, month + 1).beginning_of_week.days_ago(7)
      end
    else
      week = m[3].to_i
      if month == Date.new(year, month).beginning_of_week.days_since(day).month
        #first day in the month falls in the first partial week of the month
        date = Date.new(year, month).beginning_of_week.days_since(day + ((week - 1) * 7))
      else
        date = Date.new(year, month).beginning_of_week.days_since(day + (week * 7))
      end
    end
    date
  end
end