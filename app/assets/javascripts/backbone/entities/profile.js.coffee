@SchedulingApp.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Profile extends Entities.Model
    urlRoot: -> Routes.profiles_path()
    # idAttribute: 'user_id'
  
  class Entities.ProfilesCollection extends Entities.Collection
    model: Entities.Profile
    url: -> Routes.profiles_path()
  
  API =
    
    getProfile: ->
      profile = new Entities.Profile
      profile.fetch
        data: $.param({ user_id: App.currentUser.id })
      profile
  
  App.reqres.setHandler "profile:entity", ->
    API.getProfile()