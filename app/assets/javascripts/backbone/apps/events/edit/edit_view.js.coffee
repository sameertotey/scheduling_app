@SchedulingApp.module "EventsApp.Edit", (Edit, App, Backbone, Marionette, $, _) ->
  
 
  class Edit.Layout extends App.Views.Layout
    template: "events/edit/templates/_layout"

    regions:
      panelRegion: "#panel-region"
      eventRegion: "#event-region"
    
  class Edit.Panel extends App.Views.ItemView
    template: "events/edit/templates/_panel"

  class Edit.Event extends App.Views.ItemView
    template: "events/edit/templates/_edit"

    triggers:
      "click [data-form-button='cancel']" : "edit:event:cancel"
      "submit"                            : "update:event:submit"

    modelEvents:
      "sync": "render"

    onDomRefresh: =>
      $("#event-type").val(@model.get("event_type")?.id)

    
