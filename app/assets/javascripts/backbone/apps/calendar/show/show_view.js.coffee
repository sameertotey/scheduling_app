@SchedulingApp.module "CalendarApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Layout extends App.Views.Layout
		template: "calendar/show/templates/show_layout"

		regions:
			panelRegion: "#panel-region"
			calendarRegion: "#calendar-region"
	
	class Show.Panel extends App.Views.ItemView
		template: "calendar/show/templates/_panel"
	
	class Show.calendar extends App.Views.ItemView
    template: "calendar/show/templates/_calendar"
    onRender: ->
      console.log "rendering the calendar"
    onShow: ->
      $("#calendar").calendar
        tmpl_path: "/tmpls/",
        events_source: ->
          []
