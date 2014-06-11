@SchedulingApp.module "EventsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->
  
  class Edit.Controller extends Marionette.Controller
    
    initialize: ->
      console.log "inside the Edit controler"