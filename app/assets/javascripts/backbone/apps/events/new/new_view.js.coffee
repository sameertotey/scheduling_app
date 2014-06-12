@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->
  
  class New.Event extends App.Views.ItemView
    template: "events/new/templates/_new"

    triggers:
      "submit"                            : "new:event:submit"
      "click [data-form-button='cancel']" : "new:event:cancel"
    
