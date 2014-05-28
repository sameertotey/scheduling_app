@SchedulingApp.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
  
  class Entities.Appointment extends Entities.Model
  
  class Entities.AppointmentsCollection extends Entities.Collection
    model: Entities.Appointment
    url: -> Routes.events_path()
  
  API =
    
    getAppointmentEntities: (cb) ->
      appointments = new Entities.AppointmentsCollection
      appointments.fetch
        success: ->
          cb appoinements
  
  App.reqres.setHandler "appointment:entities", (cb) ->
    API.getAppointmentEntities cb