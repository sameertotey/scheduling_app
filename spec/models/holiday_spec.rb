require 'spec_helper'

describe Holiday do

  it { should respond_to(:day_str) }

  it { should respond_to(:description) }

  context "first_wednesday_of_month" do
    it "returns first wednesday for a year and month" do
      expect(Holiday.first_wednesday_of_month(2014,7)).to eq(Date.new(2014,7,2))
      expect(Holiday.first_wednesday_of_month(2014,8)).to eq(Date.new(2014,8,6))
      expect(Holiday.first_wednesday_of_month(2014,9)).to eq(Date.new(2014,9,3))
    end
  end

  context "second_wednesday_of_month" do
    it "returns second wednesday for a year and month" do
      expect(Holiday.second_wednesday_of_month(2014,10)).to eq(Date.new(2014,10,8))
      expect(Holiday.second_wednesday_of_month(2014,11)).to eq(Date.new(2014,11,12))
    end
  end

  context "all_fridays_of_month" do
    it "returns all fridays in a given year and month" do
      expect(Holiday.all_fridays_of_month(2014,12)).to eq([Date.new(2014,12,5),
        Date.new(2014,12,12), Date.new(2014,12,19) ,Date.new(2014,12,26)])
    end
  end

  context "all_saturdays_of_month" do
    it "returns all fridays in a given year and month" do
      expect(Holiday.all_saturdays_of_month(2014,10)).to eq([Date.new(2014,10,4),
        Date.new(2014,10,11), Date.new(2014,10,18) ,Date.new(2014,10,25)])
    end
  end

  describe "parse_day" do
    it "returns new years day" do 
      expect(Holiday.parse_day(2015, '01-01')).to eq Date.new(2015, 1, 1)
    end

    it "returns Memorial day" do 
      expect(Holiday.parse_day(2016, '05-W-1-0')).to eq Date.new(2016, 5, 30)
    end

    it "returns Independence day" do 
      expect(Holiday.parse_day(2016, '07-04')).to eq Date.new(2016, 7, 4)
    end

    it "returns Labor day" do 
      expect(Holiday.parse_day(2015, '09-W+1-0')).to eq Date.new(2015, 9, 7)
      expect(Holiday.parse_day(2016, '09-W+1-0')).to eq Date.new(2016, 9, 5)
    end

    it "returns Thanksgiving day" do 
      expect(Holiday.parse_day(2014, '11-W+4-3')).to eq Date.new(2014, 11, 27)
      expect(Holiday.parse_day(2015, '11-W+4-3')).to eq Date.new(2015, 11, 26)
      expect(Holiday.parse_day(2016, '11-W+4-3')).to eq Date.new(2016, 11, 24)
    end

    it "returns Christmas day" do 
      expect(Holiday.parse_day(2015, '12-25')).to eq Date.new(2015, 12, 25)
    end

    it "raises error when the format is invalid" do
      expect { Holiday.parse_day(2015, '12*25') }.to raise_error(
              StandardError, "Holiday: The date string could not be parsed")
    end
  end

  describe "all_holidays_for_year" do
    before(:each) { @holiday = Holiday.new(day_str: '01-01', 
              description: "January 1st, New years day") }

    it "returns empty array if no holidays are saved" do 
      expect(Holiday.all_holidays_for_year(2015)).to eq []
    end

    it "returns one saved holiday in default format" do 
      @holiday.save
      expect(Holiday.all_holidays_for_year(2015)).to eq [Date.new(2015, 1, 1)]
    end

    it "returns one saved holiday in month week day format" do 
      @holiday.day_str = '05-W-1-0'
      @holiday.save
      expect(Holiday.all_holidays_for_year(2015)).to eq [Date.new(2015, 5, 25)]
    end

    it "returns all the holidays" do
      holidays = Holiday.create([
       {day_str: '01-01', description: 'January 1st, New years day'},
       {day_str: '05-W-1-0', description: 'Last Monday of May, Memorial day'},
       {day_str: '07-04', description: 'July 4th, Inddependce day'},
       {day_str: '09-W+1-0', description: 'First Monday of September, Labor day'},
       {day_str: '11-W+4-3', description: 'Fourth Thursday in November, Thanksgiving day'},
       {day_str: '12-25', description: 'December 25, Christmas'}
       ])  
      expect(Holiday.all_holidays_for_year(2015)).to eq [Date.new(2015, 1, 1), Date.new(2015, 5, 25),Date.new(2015, 7, 4),
                                          Date.new(2015, 9, 7),Date.new(2015, 11, 26),Date.new(2015, 12, 25)]
      expect(Holiday.all_holidays_for_year(2016)).to eq [Date.new(2016, 1, 1), Date.new(2016, 5, 30),Date.new(2016, 7, 4),
                                          Date.new(2016, 9, 5),Date.new(2016, 11, 24),Date.new(2016, 12, 25)]
    end
  end
end
