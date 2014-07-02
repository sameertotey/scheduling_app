class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_type
  validates_presence_of :date, :shift, :event_type
  scope :assigned, -> {where('user_id is not null')}
  scope :unassigned, -> {where(user_id: nil)}
  validate :conflicting_events

  def self.get_events_for_range(range)
    where({date: range})
  end

  def unassigned?
    self.user_id == nil
  end

  def assigned?
    self.user_id 
  end

  def self.get_events_range_type(range, type)
    event_type = EventType.find_by(name: type)
    where({date: range, event_type: event_type})
  end

  def conflicting_events
    if (event_type.name == "no") && Event.find_by(user: user, date: date, shift: shift, event_type: EventType.find_by(name: "yes"))
      errors.add(:event_type, "there's an existing yes event, can't be a conflicting event type")
    elsif (event_type.name == "yes") && Event.find_by(user: user, date: date, shift: shift, event_type: EventType.find_by(name: "no"))
      errors.add(:event_type, "there's an existing no event, can't be a conflicting event type")
    elsif (event_type.name == "info") && Event.find_by(user: user, date: date, shift: shift, event_type: EventType.find_by(name: "no"))
      errors.add(:event_type, "there's an existing no event, can't assign")
    end
  end

end
