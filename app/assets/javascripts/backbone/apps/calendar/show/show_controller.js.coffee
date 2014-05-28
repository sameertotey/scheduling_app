@SchedulingApp.module "CalendarApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	Show.Controller =
		
		displayCalendar: ->
      appointments = []
      @layout = @getLayoutView()
      @layout.on "show", =>
        @showPanel appointments
        @showCalendar appointments	
        window.appointments = appointments 
      App.mainRegion.show @layout
		
		showPanel: (appointments) ->
			panelView = @getPanelView appointments
			@layout.panelRegion.show panelView
		
		showCalendar: (appointments) ->
      calendarView = @getCalendarView appointments
      @layout.calendarRegion.show calendarView		

		getCalendarView: (appointments) ->
			new Show.calendar
			
		getPanelView: (appointments) ->
			new Show.Panel
		
		getLayoutView: ->
			new Show.Layout