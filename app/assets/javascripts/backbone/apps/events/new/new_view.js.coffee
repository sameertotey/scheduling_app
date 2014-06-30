@SchedulingApp.module "EventsApp.New", (New, App, Backbone, Marionette, $, _) ->


  class New.Layout extends App.Views.Layout
    template: "events/new/templates/_layout"

    regions:
      panelRegion: "#panel-region"
      eventRegion: "#event-region"
    
  class New.Panel extends App.Views.ItemView
    template: "events/new/templates/_panel"
    
    App.vent.on "new:event:error", (errors = {}) ->
      text = ''
      for name, array of errors
        text += "<p>#{name}: #{array}<p>"
      $('#errors').html(text)
  
  class New.Event extends App.Views.ItemView
    template: "events/new/templates/_new"

    triggers:
      "submit"                            : "new:event:submit"
      "click [data-form-button='cancel']" : "new:event:cancel"
