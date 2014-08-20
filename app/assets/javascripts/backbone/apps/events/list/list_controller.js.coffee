@SchedulingApp.module "EventsApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Controller extends Marionette.Controller
		
		initialize: ->
			App.request "event:entities", (events) =>
        @layout = @getLayoutView()

        @layout.on "show", =>
          @showPanel events
#          @showEvents events
          @showEventsTable events
        App.mainRegion.show @layout
  		
		showPanel: (events) ->
			panelView = @getPanelView events
			@layout.panelRegion.show panelView
		
		showEvents: (events) ->
      @eventsView = @getEventsView events
      @layout.eventsRegion.show @eventsView

    showEventsTable: (events) ->
      @eventsTableView = @getEventsTableView events
      @layout.eventsTableRegion.show @eventsTableView

    getEventsTableView: (events) ->
      new List.EventsTable
        collection: events

		getEventsView: (events) ->
			new List.Events
        collection: events
			
		getPanelView: (events) ->
			new List.Panel
				collection: events
		
		getLayoutView: ->
			new List.Layout