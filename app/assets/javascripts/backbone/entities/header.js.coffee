@SchedulingApp.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Header extends Entities.Model 

  class Entities.HeaderCollection extends Entities.Collection
    model: Entities.Header

  API = 
    getHeaders: ->
      new Entities.HeaderCollection [
        { name: "Users", url: "/users"}
        { name: "Leads", url: "/leads"}
        {name: "Calendar", url: "/calendar"}
      ]

  App.reqres.setHandler "header:entities", ->
    API.getHeaders()
