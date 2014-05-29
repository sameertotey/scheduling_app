@SchedulingApp.module "CalendarApp", (CalendarApp, App, Backbone, Marionette, $, _) ->
  
  class CalendarApp.Router extends Marionette.AppRouter
    appRoutes:
      "calendar" : "showCalendar"
  
  API =
    showCalendar: ->
      CalendarApp.Show.Controller.displayCalendar()

    updateTitle: (title) ->
      CalendarApp.Show.Controller.updateTitle(title)
  
    updateView: (view) ->
      CalendarApp.Show.Controller.updateView(view)

  App.addInitializer ->
    new CalendarApp.Router
      controller: API

  App.vent.on "calendar:update:title", (title) ->
    API.updateTitle(title)

  App.vent.on "calendar:update:view", (view) ->
    API.updateView(view)
