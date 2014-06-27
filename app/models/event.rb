class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_type
  validates_presence_of :date, :shift, :event_type, :user

  def self.get_events_for_range(range)
    where({date: range})
  end

end
