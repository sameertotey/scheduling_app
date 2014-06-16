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

    events: 
      "click a": "navigateEvent"

    navigateEvent: (e) ->
      $('[data-original-title]').popover('hide');
      $('[data-original-title]').tooltip('hide');
      App.navigate Routes.edit_event_path($(e.currentTarget).data('event-id')), trigger: true

    onRender: ->
      @eventsrc = _.each @collection.toJSON(), (element) ->
        seven_thirty = 27000000
        six_hours = 21600000
        afternoon_shift = 48600000
        offset = if element.shift == 1 then seven_thirty else afternoon_shift
        _.extend element,
          start: moment(element.date) + offset  
          end: moment(element.date) + offset + six_hours
          # url: "#" + Routes.edit_event_path(element.id)
          title: element.profile.initials + ' ' + element.event_type.name
          class: element.profile.css_class + ' ' + element.event_type.css_class


    onShow: ->
      events = @eventsrc
      window.cal_eve = events
      App.calendar_control = $("#calendar").calendar
        onAfterViewLoad: (view) ->
          App.vent.trigger "calendar:update:title", this.getTitle()
          App.vent.trigger "calendar:update:view", view
        tmpl_path: "/tmpls/",
        events_source: 
          events
        time_start:         '07:00',
        time_end:           '20:00',
        time_split:         '30',
        first_day: 2,
        holidays:  {
          # // January 1
          '01-01':  "New Year's Day",
          # // Last (-1*) Monday (1) in May (05)
          '05-1*1': "Memorial Day",
          # // July 4
          '04-07':  "Independence Day",
          # // First (+1*) Monday (1) in September (09)
          '09+1*1': "Labor Day",
          # // Fourth (+4*) Thursday (4) in November (11)
          '11+4*4': "Thanksgiving Day",
          # // December 25
          '25-12':  "Christmas"
        }
          
