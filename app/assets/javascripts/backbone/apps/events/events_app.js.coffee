@SchedulingApp.module "EventsApp", (EventsApp, App, Backbone, Marionette, $, _) ->
	
	class EventsApp.Router extends Marionette.AppRouter
		appRoutes:
      "events"           : "listEvents"
      "events/:id/edit"  : "editEvent"

	
	API =
		listEvents: ->
      new EventsApp.List.Controller

    editEvent: ->
      new EventsApp.Edit.Controller
	
	App.addInitializer ->
		new EventsApp.Router
			controller: API