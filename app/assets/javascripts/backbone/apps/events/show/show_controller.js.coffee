@SchedulingApp.module "EventsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Controller extends Marionette.Controller
    
    initialize: ->
      console.log "inside the show controler"