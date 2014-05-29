@SchedulingApp.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Event extends Entities.Model
  
  class Entities.EventsCollection extends Entities.Collection
    model: Entities.Event
    url: -> Routes.events_path()
  
  API =
    
    getEventEntities: (cb) ->
      events = new Entities.AppointmentsCollection
      events.fetch
        success: ->
          cb events
  
  App.reqres.setHandler "event:entities", (cb) ->
    API.getEventEntities cb