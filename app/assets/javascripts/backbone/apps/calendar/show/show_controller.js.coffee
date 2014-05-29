@SchedulingApp.module "CalendarApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	Show.Controller =
    
    displayCalendar: ->
      appointments = []
      @CalenderTitle = new Backbone.Model
        title: "Sameer"
        view: "month"
      @layout = @getLayoutView()
      @layout.on "show", =>
        @showPanel @CalenderTitle
        @showCalendar appointments	
        window.appointments = appointments 
      App.mainRegion.show @layout

    updateTitle: (title) ->
      @CalenderTitle.set
        title: title
    
    updateView: (view) ->
      @CalenderTitle.set
        view: view

    showPanel: (title) ->
      panelView = @getPanelView title
      @layout.panelRegion.show panelView
    
    showCalendar: (appointments) ->
      calendarView = @getCalendarView appointments
      @layout.calendarRegion.show calendarView    

    getCalendarView: (appointments) ->
      new Show.Calendar
      
    getPanelView: (title) ->
      new Show.Panel 
        model: title

    getLayoutView: ->
      new Show.Layout


