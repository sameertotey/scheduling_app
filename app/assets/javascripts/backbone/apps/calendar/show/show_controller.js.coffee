@SchedulingApp.module "CalendarApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	Show.Controller =
    
    displayCalendar: ->
      @calenderTitle = new Backbone.Model
        title: "Calendar"
        view: "month"
      App.request "event:entities", (events) =>
        @layout = @getLayoutView()
        @layout.on "show", =>
          @showPanel @calenderTitle
          @showCalendar events	
        App.mainRegion.show @layout

    updateTitle: (title) ->
      @calenderTitle.set
        title: title
    
    updateView: (view) ->
      @calenderTitle.set
        view: view

    showPanel: (title) ->
      panelView = @getPanelView title
      @layout.panelRegion.show panelView
    
    showCalendar: (events) ->
      calendarView = @getCalendarView events
      @layout.calendarRegion.show calendarView    

    getCalendarView: (events) ->
      new Show.Calendar
        collection: events
      
    getPanelView: (title) ->
      new Show.Panel 
        model: title

    getLayoutView: ->
      new Show.Layout


