@SchedulingApp.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.EventType extends Entities.Model 

  class Entities.EventTypesCollection extends Entities.Collection
    model: Entities.EventType
    url: Routes.event_types_path()

  API = 
    getEventTypes: ->
      event_types = new Entities.EventTypesCollection
      event_types.fetch
        reset: true
      event_types

  App.reqres.setHandler "eventtype:entities", ->
    API.getEventTypes()


