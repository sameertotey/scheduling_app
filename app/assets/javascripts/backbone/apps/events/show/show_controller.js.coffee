@SchedulingApp.module "EventsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  
  class Show.Controller extends Marionette.Controller
    
    initialize: (options) ->
      { event, id } = options
      event or= App.request "event:entity", id
      @layout = @getLayoutView()
      @layout.on "show", =>
        @showPanel event
        @showEvent event 

      $('[data-original-title]').popover('hide');
      $('[data-original-title]').tooltip('hide');
      App.mainRegion.show @layout

      @listenTo @showView, "show:event:cancel", ->
        window.history.back()

    showPanel: (event) ->
      panelView = @getPanelView event
      @layout.panelRegion.show panelView
      
    showEvent: (event) ->
      @showView = @getShowView event
      @layout.eventRegion.show @showView
      
    getShowView: (event) ->
      new Show.Event
        model: event

    getPanelView: (event) ->
      new Show.Panel
        model: event
    
    getLayoutView: ->
      new Show.Layout
