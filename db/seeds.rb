# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

events = Event.create([
  {date: '2014-05-14', comment:'This is a comment', shift: 1},
  {date: '2014-05-17', comment:'This is test test test!', shift: 2}
])