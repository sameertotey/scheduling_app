@SchedulingApp.module "EventsApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Controller extends Marionette.Controller
		
		initialize: ->
			App.request "event:entities", (events) =>
        @layout = @getLayoutView()
        @layout.on "show", =>
          @showPanel events
          @showEvents events	
          window.events = events  
        App.mainRegion.show @layout
		
		showPanel: (events) ->
			panelView = @getPanelView events
			@layout.panelRegion.show panelView
		
		showEvents: (events) ->
      eventsView = @getEventsView events
      @layout.eventsRegion.show eventsView
		
		getEventsView: (events) ->
			new List.Events
        collection: events
			
		getPanelView: (events) ->
			new List.Panel
				collection: events
		
		getLayoutView: ->
			new List.Layout