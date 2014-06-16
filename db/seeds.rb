# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

event_types = EventType.create([
  {name: 'yes', description: 'request this shift', css_class: 'event-inverse'},
  {name: 'no', description: 'decline this shift', css_class: 'event-warning'},
  {name: 'info', description: 'information only', css_class: 'event-info'}
  ])