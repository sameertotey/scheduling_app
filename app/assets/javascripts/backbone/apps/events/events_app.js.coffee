@SchedulingApp.module "EventsApp", (EventsApp, App, Backbone, Marionette, $, _) ->
	
	class EventsApp.Router extends Marionette.AppRouter
		appRoutes:
      "events"             : "listEvents"
      "events/new(:date)"  : "newEvent"
      "events/:id"         : "showEvent"
      "events/:id/edit"    : "editEvent"

	API =
		listEvents: ->
      new EventsApp.List.Controller

    newEvent: (date) ->
      console.log "The date passed was #{date}"
      App.navigate Routes.new_event_path()
      new EventsApp.New.Controller date

    showEvent: (id, model) ->
      # App.navigate Routes.edit_event_path(id)
      # API.editEvent id
      new EventsApp.Show.Controller 
        id: id
        event: model

    editEvent: (id, model) ->
      new EventsApp.Edit.Controller 
        id: id
        event: model

    deleteEvent: (model) ->
      if confirm "Are you sure you want to delete #{model.get("comment")}?" 
        model.destroy
          success: ->
            App.navigate Routes.events_path()
            API.listEvents()
	
	App.addInitializer ->
		new EventsApp.Router
			controller: API

  App.vent.on "delete:event", (model) ->
    API.deleteEvent(model)

  App.vent.on "show:event", (model) ->
    if App.currentUser.id == model.get("user").id
      App.navigate Routes.edit_event_path(model.id)
      API.editEvent model.id, model
    else
      App.navigate Routes.event_path(model.id)
      API.showEvent model.id, model