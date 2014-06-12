@SchedulingApp.module "EventsApp", (EventsApp, App, Backbone, Marionette, $, _) ->
	
	class EventsApp.Router extends Marionette.AppRouter
		appRoutes:
      "events"           : "listEvents"
      "events/:id/edit"  : "editEvent"
      "events/new"       : "newEvent"

	
	API =
		listEvents: ->
      new EventsApp.List.Controller

    editEvent: ->
      new EventsApp.Edit.Controller

    newEvent: ->
      new EventsApp.New.Controller

    deleteEvent: (model) ->
      if confirm "Are you sure you want to delete #{model.get("comment")}?" then model.destroy() else false
	
	App.addInitializer ->
		new EventsApp.Router
			controller: API

  App.vent.on "delete:event", (model) ->
    API.deleteEvent(model)