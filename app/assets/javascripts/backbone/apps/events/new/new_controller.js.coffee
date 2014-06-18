@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->
  
  class New.Controller extends Marionette.Controller
    
    initialize: ->
      event = App.request "new:event:entity"
      @layout = @getLayoutView()
      @layout.on "show", =>
        @showPanel event
        @showEvent event 
      App.mainRegion.show @layout

      @listenTo @newView, "new:event:cancel", ->
        window.history.back();

      @listenTo @newView, "new:event:submit", (args) ->
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            window.history.back()
    
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
