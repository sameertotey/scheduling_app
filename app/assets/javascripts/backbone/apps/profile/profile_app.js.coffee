@SchedulingApp.module "ProfileApp", (ProfileApp, App, Backbone, Marionette, $, _) ->
	
	class ProfileApp.Router extends Marionette.AppRouter
		appRoutes:
			"profile" : "showProfile"
		
		API =
			showProfile: ->
				new ProfileApp.Show.Controller
		
		App.addInitializer ->
			new ProfileApp.Router
				controller: API