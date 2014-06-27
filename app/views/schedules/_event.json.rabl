attributes :id, :date, :shift, :comment, :user, :event_type
node :profile do |event|
  event.user.profile
end
  