@SchedulingApp.module "ProfileApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller

    initialize: ->
      profile = App.request "profile:entity"
      console.log "profile:entity", profile
      @layout = @getLayoutView()
      @layout.on "show", =>
        console.log "inside after show"
        @showPanel profile
        @showProfile profile 
      App.mainRegion.show @layout

    showPanel: (profile) ->
      console.log "inside show panel"
      panelView = @getPanelView profile
      @layout.panelRegion.show panelView
      
    showProfile: (profile) ->
      console.log "inside show profile"
      profileView = @getProfileView profile
      @layout.profileRegion.show profileView
      
    getProfileView: (profile) ->
      new Show.Profile
        model: profile
      
    getPanelView: (profile) ->
      new Show.Panel
        model: profile
    
    getLayoutView: ->
      new Show.Layout