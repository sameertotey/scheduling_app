@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends Marionette.Controller
    
    initialize: ->
      event = App.request "new:event:entity"
      @newView = @getNewView event
      App.mainRegion.show @newView

      @listenTo @newView, "new:event:cancel", ->
        window.history.back();


      @listenTo @newView, "new:event:submit", (args) ->
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            window.history.back()

    
    getNewView: (event) ->
      new New.Event
        model: event