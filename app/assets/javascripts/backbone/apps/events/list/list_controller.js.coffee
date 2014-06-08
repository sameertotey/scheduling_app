@SchedulingApp.module "EventsApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	List.Controller =
		
		listEvents: ->
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
      console.log "inside showEvents"
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