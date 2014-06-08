@SchedulingApp.module "CalendarApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Layout extends App.Views.Layout
		template: "calendar/show/templates/show_layout"

		regions:
			panelRegion: "#panel-region"
			calendarRegion: "#calendar-region"
	
	class Show.Panel extends App.Views.ItemView
    template: "calendar/show/templates/_panel"
  
    ui:
      "view_btns": ".btn-group button[data-calendar-view]"
      "nav_btns": ".btn-group button[data-calendar-nav]"
  
    events:
      "click @ui.view_btns": "clickView"
      "click @ui.nav_btns": "clickNav"
  
    modelEvents:
      "change:title" : "render"
      "change:view"  : "activeChange"

    clickView: (e) ->
      App.calendar_control.view($(e.currentTarget).data('calendar-view'))

    clickNav: (e) ->
      App.calendar_control.navigate($(e.currentTarget).data('calendar-nav'))

    activeChange: (model, val) ->
      $('.btn-group button').removeClass('active');
      $('button[data-calendar-view="' + val + '"]').addClass('active');
	
	class Show.Calendar extends App.Views.ItemView
    template: "calendar/show/templates/_calendar"

    onRender: ->
      console.log "in on render", @collection
      console.log "toJSON: ", @collection.toJSON()
      @events = @collection.toJSON()
      console.log "eventsrc ", @events

    onShow: ->
      console.log "in on show"
      events = @collection.toJSON()
      console.log "see this ", JSON.stringify(@collection.toJSON())
      App.calendar_control = $("#calendar").calendar
        onAfterViewLoad: (view) ->
          App.vent.trigger "calendar:update:title", this.getTitle()
          App.vent.trigger "calendar:update:view", view
        tmpl_path: "/tmpls/",
        events_source: ->
          events
          
