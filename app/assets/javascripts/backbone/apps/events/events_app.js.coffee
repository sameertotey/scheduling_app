@SchedulingApp.module "EventsApp", (EventsApp, App, Backbone, Marionette, $, _) ->
	
	class EventsApp.Router extends Marionette.AppRouter
		appRoutes:
			"events"	: "listEvents"
	
	API =
		listEvents: ->
      EventsApp.List.Controller.listEvents()
	
	App.addInitializer ->
		new EventsApp.Router
			controller: API