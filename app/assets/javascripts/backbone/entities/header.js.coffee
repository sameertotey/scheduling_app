@SchedulingApp.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Header extends Entities.Model 

  class Entities.HeaderCollection extends Entities.Collection
    model: Entities.Header

  API = 
    getHeaders: ->
      new Entities.HeaderCollection [
        { name: "Calendar", url: "calendar", fragment: true}
        { name: "Events", url: "events", fragment: true}
        { name: "Edit profile", url: "profile", fragment: true}
        { name: "Sign up", url: Routes.new_user_registration_path(), fragment: false, signed_in: false, admin: false}
        { name: "Sign in", url: Routes.new_user_session_path(), fragment: false, signed_in: false, admin: false}
        { name: "Edit account", url: Routes.edit_user_registration_path(), fragment: false, signed_in: true, admin: false}
        { name: "Sign out", url: Routes.destroy_user_session_path(), fragment: false, signed_in: true, admin: false}

        { name: "Users", url: Routes.users_path(), fragment: false, signed_in: true, admin: true}
        { name: "Holidays", url: Routes.holidays_path(), fragment: false, signed_in: true, admin: true}
        { name: "App setting", url: Routes.app_settings_path(), fragment: false, signed_in: true, admin: true}
        { name: "Schedule", url: Routes.schedule_path(), fragment: false, signed_in: true, admin: true}
      ]

  App.reqres.setHandler "header:entities", ->
    API.getHeaders()
