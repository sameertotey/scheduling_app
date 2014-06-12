@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends Marionette.Controller
    
    initialize: ->
      eventtypes = App.request "eventtype:entities"
      window.eventtypes = eventtypes
      event = App.request "new:event:entity"
      
      @newView = @getNewView event
      App.mainRegion.show @newView

      @listenTo @newView, "new:event:cancel", ->
        console.log "new event cancel"
        App.navigate Routes.events_path(), trigger: true


      @listenTo @newView, "new:event:submit", (args) ->
        console.log "submit", args
        data = Backbone.Syphon.serialize args.view
        args.model.set(data)
        args.model.save
          success: App.navigate Routes.events_path()
    
    getNewView: (event) ->
      new New.Event
        model: event