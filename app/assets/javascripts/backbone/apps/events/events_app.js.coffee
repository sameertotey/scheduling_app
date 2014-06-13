@SchedulingApp.module "EventsApp", (EventsApp, App, Backbone, Marionette, $, _) ->
	
	class EventsApp.Router extends Marionette.AppRouter
		appRoutes:
      "events"           : "listEvents"
      "events/new"       : "newEvent"
      "events/:id"       : "showEvent"
      "events/:id/edit"  : "editEvent"

	API =
		listEvents: ->
      new EventsApp.List.Controller

    newEvent: ->
      new EventsApp.New.Controller

    showEvent: (id) ->
      App.navigate Routes.edit_event_path(id)
      API.editEvent id

    editEvent: (id, model) ->
      new EventsApp.Edit.Controller 
        id: id
        event: model

    deleteEvent: (model) ->
      if confirm "Are you sure you want to delete #{model.get("comment")}?" 
        model.destroy
          success: ->
            App.navigate Routes.events_path(), trigger: true
            API.listEvents()
	
	App.addInitializer ->
		new EventsApp.Router
			controller: API

  App.vent.on "delete:event", (model) ->
    API.deleteEvent(model)

  App.vent.on "edit:event", (model) ->
    App.navigate Routes.edit_event_path(model.id)
    API.editEvent model.id, model