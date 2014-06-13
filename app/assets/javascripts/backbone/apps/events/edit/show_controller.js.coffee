@SchedulingApp.module "EventsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->
  
  class Edit.Controller extends Marionette.Controller
    
    initialize: (options) ->
      { event, id } = options
      event or= App.request "event:entity", id

      @editView = @getEditView event
      App.mainRegion.show @editView

      @listenTo @editView, "edit:event:cancel", ->
        App.navigate Routes.events_path(), trigger: true

      @listenTo @editView, "update:event:submit", (args) ->
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            App.navigate Routes.events_path(), trigger: true


    getEditView: (event) ->
      new Edit.Event
        model: event