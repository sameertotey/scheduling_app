@SchedulingApp.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Event extends Entities.Model
    urlRoot: -> Routes.events_path()

  
  class Entities.EventsCollection extends Entities.Collection
    model: Entities.Event
    url: -> Routes.events_path()
  
  API =
    
    getEventEntities: (cb) ->
      events = new Entities.EventsCollection
      events.fetch
        success: ->
          cb events

    newEvent: ->
      new Entities.Event
  
  App.reqres.setHandler "event:entities", (cb) ->
    API.getEventEntities cb

  App.reqres.setHandler "new:event:entity", ->
    API.newEvent()