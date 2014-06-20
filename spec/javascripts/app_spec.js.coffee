
describe 'SchedulingApp', ->
  it 'has initial currentUser property undefined', ->
    expect(SchedulingApp.currentUser).toBe(undefined)

  it 'has initial environment property undefined', ->
    expect(SchedulingApp.environment).toBe(undefined) 

  it 'has initial eventTypes property undefined', ->
    expect(SchedulingApp.eventTypes).toBe(undefined)    

  it 'has initial HeaderApp property defined', ->
    expect(SchedulingApp.HeaderApp).not.toBe(undefined)    

  it 'has initial FooterApp property undefined', ->
    expect(SchedulingApp.FooterApp).not.toBe(undefined)    

  it 'has initial EventsApp property undefined', ->
    expect(SchedulingApp.EventsApp).not.toBe(undefined)   
    
  it 'has initial CalendarApp property undefined', ->
    expect(SchedulingApp.CalendarApp).not.toBe(undefined)   
    
  it 'has initial ProfileApp property undefined', ->
    expect(SchedulingApp.ProfileApp).not.toBe(undefined)   
    
  it 'has initial UsersApp property undefined', ->
    expect(SchedulingApp.UsersApp).not.toBe(undefined) 

  it 'has initial rootRoute set', ->
    expect(SchedulingApp.rootRoute).toBe("/calendar")                   