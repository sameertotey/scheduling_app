@SchedulingApp.module "EventsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->
  
  class Edit.Controller extends Marionette.Controller
    
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

      @listenTo @editView, "edit:event:cancel", ->
        window.history.back()

      @listenTo @editView, "update:event:submit", (args) ->
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            window.history.back()

    showPanel: (event) ->
      panelView = @getPanelView event
      @layout.panelRegion.show panelView
      
    showEvent: (event) ->
      @editView = @getEditView event
      @layout.eventRegion.show @editView
      
    getEditView: (event) ->
      new Edit.Event
        model: event

    getPanelView: (event) ->
      new Edit.Panel
        model: event
    
    getLayoutView: ->
      new Edit.Layout
