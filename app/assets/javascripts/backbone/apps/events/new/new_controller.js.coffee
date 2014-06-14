@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends Marionette.Controller
    
    initialize: ->
      event = App.request "new:event:entity"
      @newView = @getNewView event
      App.mainRegion.show @newView

      @listenTo @newView, "new:event:cancel", ->
        App.navigate Routes.events_path(), trigger: true


      @listenTo @newView, "new:event:submit", (args) ->
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            App.navigate Routes.events_path(), trigger: true

    
    getNewView: (event) ->
      new New.Event
        model: event