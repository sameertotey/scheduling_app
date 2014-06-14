@SchedulingApp.module "Views", (Views, App, Backbone, Marionette, $, _) ->
	
	_.extend Marionette.View::,
	
    templateHelpers: ->
      
      linkTo: (name, url, options = {}) ->
        _.defaults options,
          external: false
        
        url = "#" + url unless options.external
        
        "<a href='#{url}'>#{@escape(name)}</a>"

      currentUser:
        App.request("get:current:user").toJSON()

      eventTypeOptions: ->
        html_str = ""
        _.each App.eventTypes, (type) ->
          html_str += "<option value='#{type.id}'>#{type.name} - #{type.description}</option>"
        html_str

