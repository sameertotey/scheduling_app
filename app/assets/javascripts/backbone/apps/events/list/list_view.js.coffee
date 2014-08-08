@SchedulingApp.module "EventsApp.List", (List, App, Backbone, Marionette, $, _) ->
	
	class List.Layout extends App.Views.Layout
		template: "events/list/templates/list_layout"

		regions:
      panelRegion: "#panel-region"
      eventsTableRegion: "#events-table-region"
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
      "dblclick"                   : "showEvent"

    clickDelete: ->
      App.vent.trigger "delete:event", @model 

    showEvent: ->
      App.vent.trigger "show:event", @model 
  
	class List.Empty extends App.Views.ItemView
		template: "events/list/templates/_empty"
		tagName:  "tr"

  class List.Events extends App.Views.CompositeView
    itemView:           List.Event
    itemViewContainer:  "tbody"
    template:           "events/list/templates/_events"
    emptyView:          List.Empty

  class List.EventsTable extends App.Views.ItemView
    template: "events/list/templates/events_table"

    onRender: ->
      events = @collection

      eventTypes = _.map App.eventTypes, (type) ->
        ["#{type.name} - #{type.description}", type.id]

      EventTypeCell = Backgrid.EventTypeCell = Backgrid.SelectCell.extend
        render: ->
          @$el.empty()
          @$el.text(@formatter.fromRaw(@model.get(@column.get("name")).name, @model));
          @delegateEvents()
          @
      EventTypeFormatter = Backgrid.EventTypeFormatter = ->
      EventTypeFormatter.prototype = new Backgrid.CellFormatter
      _.extend EventTypeFormatter.prototype,
        fromRaw:  (rawValue, model) ->
          rawValue + ''

        toRaw: (formattedData, model) ->
          id = parseInt(formattedData)
          formattedData = eventType for eventType in App.eventTypes when eventType.id == id
          formattedData

      EventTypeCellEditor = Backgrid.EventTypeCellEditor = Backgrid.SelectCellEditor.extend
        render: ->
          @$el.empty();
          optionValues = _.result(this, "optionValues");
          model = this.model;
          selectedValues = model.get @column.get("name")

          for optionValue in optionValues
            if (_.isArray(optionValue))
              optionText  = optionValue[0];
              optionValue = optionValue[1];

              @$el.append @template
                text: optionText,
                value: optionValue,
                selected: selectedValues.id == optionValue

          @delegateEvents()
          @


      @eventTable = new Backgrid.Grid
        columns: [{
          name: "id"
          label: "ID"
          editable: false
          cell: Backgrid.IntegerCell.extend
            orderSeparator: ''
        },
        {
          name: "date"
          label: "Date"
          cell: "date"
        },
        {
          name: "comment"
          label: "Comment"
          cell: "string"
        },
        {
          name: "shift"
          label: "Shift"
          cell: Backgrid.SelectCell.extend
            optionValues: [["AM", "1"], ["PM", "2"]]
        },
        {
          name: "event_type"
          label: "Event Type"
          formatter: "EventType"
          cell: Backgrid.EventTypeCell.extend
            optionValues: eventTypes
            editor: EventTypeCellEditor
        }
        ]
        collection: @collection

    onShow: ->
      $('#events-table').html(@eventTable.render().el)






