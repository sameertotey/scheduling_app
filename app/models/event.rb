class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_type
  validates_presence_of :date, :shift, :event_type
  scope :assigned, -> {where('user_id is not null')}
  scope :unassigned, -> {where(user_id: nil)}

  def self.get_events_for_range(range)
    where({date: range})
  end

  def unassigned?
    self.user_id == nil
  end

end
