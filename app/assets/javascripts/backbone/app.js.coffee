@SchedulingApp = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.rootRoute = Routes.root_path()

  App.on "initialize:before", (options) ->
    @currentUser = App.request "set:current:user", options.currentUser

  App.reqres.setHandler "get:current:user", ->
    App.currentUser

  App.addRegions 
    headerRegion: "#header-region"
    mainRegion:   "#main-region"
    footerRegion: "#footer-region"

  App.addInitializer ->
    App.module("FooterApp").start()
    App.module("HeaderApp").start()

  App.on "initialize:after", ->
    if Backbone.history
      Backbone.history.start
        hashChange: true
    @navigate(@rootRoute, trigger: true) if @getCurrentRoute() is ""

  App
