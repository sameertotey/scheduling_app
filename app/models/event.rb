class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_type
  validates_presence_of :date, :shift, :event_type
  scope :assigned, -> {where('user_id is not null')}
  scope :unassigned, -> {where(user_id: nil)}
  validate :conflicting_event_types
  validate :conflicting_shifts
  after_rollback :transaction_failed

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

  def self.assign_user(event, user)
    event.user = user
    event.save
  end

  def self.assign_user_to_list(events, user)
    Event.transaction do
      events.each do |event|
        event.user = user
        event.save!
      end
    end
  end

  private

  def transaction_failed
    logger.warn "Event transaction failed #{self.inspect}"
  end  

  def conflicting_event_types
    if (event_type.name == "no") && Event.find_by(user: user, date: date, shift: shift, event_type: EventType.find_by(name: "yes"))
      errors.add(:event_type, "there's an existing yes event, can't be a conflicting event type")
    elsif (event_type.name == "yes") && Event.find_by(user: user, date: date, shift: shift, event_type: EventType.find_by(name: "no"))
      errors.add(:event_type, "there's an existing no event, can't be a conflicting event type")
    elsif (event_type.name == "info") && Event.find_by(user: user, date: date, shift: shift, event_type: EventType.find_by(name: "no"))
      errors.add(:event_type, "there's an existing no event, can't assign")
    end
  end

  def conflicting_shifts
    if user && (event_type.name == "info") && Event.find_by(user: user, date: date, shift: shift, event_type: EventType.find_by(name: "info"))
      errors.add(:shift, "there's an existing shift for same user, can't assign a conflicting shift")
    end
  end

end
