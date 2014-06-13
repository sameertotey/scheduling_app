@SchedulingApp.module "EventsApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Layout extends App.Views.Layout
		template: "events/list/templates/list_layout"

		regions:
			panelRegion: "#panel-region"
			eventsRegion: "#events-region"
	
	class List.Panel extends App.Views.ItemView
    template: "events/list/templates/_panel"
    triggers:
      "click #new-crew" : "new:crew:button:clicked"

	class List.Event extends App.Views.ItemView
    template: "events/list/templates/_event"
    tagName: "tr"
    className: "list-event"

    events:
      "click .event-delete button" : "clickDelete"
      "dblclick"       : "editEvent"

    clickDelete: ->
      App.vent.trigger "delete:event", @model 

    editEvent: ->
      App.vent.trigger "edit:event", @model 
  
	class List.Empty extends App.Views.ItemView
		template: "events/list/templates/_empty"
		tagName:  "tr"
	
	class List.Events extends App.Views.CompositeView
    itemView:           List.Event
    itemViewContainer: "tbody"
    template:           "events/list/templates/_events"
    emptyView:          List.Empty
