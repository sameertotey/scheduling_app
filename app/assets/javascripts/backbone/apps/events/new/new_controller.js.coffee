@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends Marionette.Controller
    
    initialize: ->
      event = App.request "new:event:entity"
      
      @newView = @getNewView event
      App.mainRegion.show @newView

      @listenTo @newView, "new:event:cancel", ->
        console.log "new event cancel"

      @listenTo @newView, "new:event:submit", (args) ->
        console.log "submit", args
        data = Backbone.Syphon.serialize args.view
        args.model.set(data)
        args.model.save()
        console.log "new event submit", data

    
    getNewView: (event) ->
      new New.Event
        model: event