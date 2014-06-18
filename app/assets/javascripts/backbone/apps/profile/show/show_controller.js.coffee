@SchedulingApp.module "ProfileApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller

    initialize: ->
      profile = App.request "profile:entity"
      console.log "profile:entity", profile
      @layout = @getLayoutView()
      @layout.on "show", =>
        @showPanel profile
        @showProfile profile 

      App.mainRegion.show @layout

      @listenTo @profileView, "update:profile:cancel", ->
        window.history.back();

      @listenTo @profileView, "update:profile:submit", (args) ->
        data = Backbone.Syphon.serialize args.view
        args.model.save data,
          success: (model, response, options) ->
            window.history.back()


    showPanel: (profile) ->
      panelView = @getPanelView profile
      @layout.panelRegion.show panelView
      
    showProfile: (profile) ->
      @profileView = @getProfileView profile
      @layout.profileRegion.show @profileView
      
    getProfileView: (profile) ->
      new Show.Profile
        model: profile
      
    getPanelView: (profile) ->
      new Show.Panel
        model: profile
    
    getLayoutView: ->
      new Show.Layout
