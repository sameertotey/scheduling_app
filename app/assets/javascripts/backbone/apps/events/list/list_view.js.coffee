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
	
	class List.Empty extends App.Views.ItemView
		template: "events/list/templates/_empty"
		tagName: "tr"
	
	class List.Events extends App.Views.CompositeView
		template: "events/list/templates/_events"
		itemView: List.Event
		emptyView: List.Empty
		itemViewContainer: "tbody"