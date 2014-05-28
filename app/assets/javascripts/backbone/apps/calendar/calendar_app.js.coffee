@SchedulingApp.module "CalendarApp", (CalendarApp, App, Backbone, Marionette, $, _) ->
  
  class CalendarApp.Router extends Marionette.AppRouter
    appRoutes:
      "calendar" : "showCalendar"
  
  API =
    showCalendar: ->
      CalendarApp.Show.Controller.displayCalendar()
  
  App.addInitializer ->
    new CalendarApp.Router
      controller: API