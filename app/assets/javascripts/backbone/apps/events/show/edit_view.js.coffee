@SchedulingApp.module "EventsApp.Show", (Show, App, Backbone, Marionette, $, _) ->
  
 
  class Show.Layout extends App.Views.Layout
    template: "events/show/templates/_layout"

    regions:
      panelRegion: "#panel-region"
      eventRegion: "#event-region"
    
  class Show.Panel extends App.Views.ItemView
    template: "events/show/templates/_panel"

  class Show.Event extends App.Views.ItemView
    template: "events/show/templates/_show"

    triggers:
      "click [data-button='cancel']" : "show:event:cancel"

    modelEvents:
      "sync": "render"
    
