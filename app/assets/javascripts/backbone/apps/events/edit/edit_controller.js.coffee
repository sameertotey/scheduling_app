@SchedulingApp.module "EventsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->
  
  class Edit.Controller extends Marionette.Controller
    
    initialize: (options) ->
      { event, id } = options
      event or= App.request "event:entity", id

      @editView = @getEditView event
      $('[data-original-title]').popover('hide');
      $('[data-original-title]').tooltip('hide');
      App.mainRegion.show @editView

      @listenTo @editView, "edit:event:cancel", ->
        window.history.back()

      @listenTo @editView, "update:event:submit", (args) ->
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            window.history.back()


    getEditView: (event) ->
      new Edit.Event
        model: event