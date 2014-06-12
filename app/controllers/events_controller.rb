class EventsController < ApplicationController
  respond_to :json

  def index
    @events = Event.all
  end

  def create
    @event = Event.new
    if @event.update_attributes event_params
      render "events/show"
    else
      respond_with @event
    end
  end

  def event_params
    params.require(:event).permit(:date, :comment, :shift)
  end
end
