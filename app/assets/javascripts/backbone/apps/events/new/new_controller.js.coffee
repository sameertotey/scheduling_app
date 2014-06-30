@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends Marionette.Controller
    
    initialize: (date) ->
      event = App.request "new:event:entity"
      event.set("date", date)
      @layout = @getLayoutView()
      @layout.on "show", =>
        @showPanel event
        @showEvent event 
      App.mainRegion.show @layout

      @listenTo @newView, "new:event:cancel", ->
        $('#errors').html()
        window.history.go(-2);

      @listenTo @newView, "new:event:submit", (args) ->
        $('#errors').html()
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            window.history.go(-2)
          error: (model, response, options) ->
            App.vent.trigger "new:event:error", response.responseJSON.errors
    
    
    showPanel: (event) ->
      panelView = @getPanelView event
      @layout.panelRegion.show panelView
      
    showEvent: (event) ->
      @newView = @getNewView event
      @layout.eventRegion.show @newView
      
    getNewView: (event) ->
      new New.Event
        model: event

    getPanelView: (event) ->
      new New.Panel
        model: event
    
    getLayoutView: ->
      new New.Layout
