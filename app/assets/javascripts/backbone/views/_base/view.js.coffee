@SchedulingApp.module "Views", (Views, App, Backbone, Marionette, $, _) ->
	
	_.extend Marionette.View::,
	
    templateHelpers: ->
      
      linkTo: (name, url, options = {}) ->
        _.defaults options,
          fragment: false
          admin: false
          signedin: true
        
        url = "#" + url if options.fragment

        current_user = App.request("get:current:user")
        if current_user.id then signed_in = true else signed_in = false
        is_admin = current_user.get("admin")

        if (options.admin == is_admin) and (options.signedin == signed_in)  
          "<a href='#{url}'>#{@escape(name)}</a>"

      currentUser:
        App.request("get:current:user").toJSON()

      eventTypeOptions: ->
        html_str = ''
        _.each App.eventTypes, (type) ->
          html_str += "<option value='#{type.id}'>#{type.name} - #{type.description}</option>"
        html_str

