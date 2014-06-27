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

holidays = Holiday.create([
  {day_str: '01-01', description: 'January 1st, New years day'},
  {day_str: '05-W-1-0', description: 'Last Monday of May, Memorial day'},
  {day_str: '07-04', description: 'July 4th, Inddependce day'},
  {day_str: '09-W+1-0', description: 'First Monday of September, Labor day'},
  {day_str: '11-W+4-3', description: 'Fourth Thursday in November, Thanksgiving day'},
  {day_str: '12-25', description: 'December 25, Christmas'}
  ])  
