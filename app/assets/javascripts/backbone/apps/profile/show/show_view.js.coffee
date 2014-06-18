@SchedulingApp.module "ProfileApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	
	class Show.Layout extends App.Views.Layout
    template: "profile/show/templates/_layout"

    regions:
      panelRegion: "#panel-region"
      profileRegion: "#profile-region"
    
  class Show.Panel extends App.Views.ItemView
    template: "profile/show/templates/_panel"

  class Show.Profile extends App.Views.ItemView
    template: "profile/show/templates/_profile"
