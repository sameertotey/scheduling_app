class EventsController < ApplicationController
  before_filter :authenticate_user! 
  respond_to :json

  def index
    @events = Event.assigned
  end

  def create
    @event = Event.new event_params
    @event.user = current_user
    @event.event_type = get_event_type
    if @event.save
      render "events/show"
    else
      render "events/errors", status: 422
    end
  end

  def destroy
    event = Event.find params[:id]
    event.destroy()
    render json: {}
  end

  def show
    @event = Event.find params[:id]
  end
  
  def update
    @event = Event.find params[:id]
    @event.event_type = get_event_type
    if @event.update_attributes event_params
      render "events/show"
    else
      render "events/errors", status: 422
    end
  end

  private

  def event_params
    params.require(:event).permit(:date, :comment, :shift)
  end

  def get_event_type
    EventType.find params[:event_type_id]
  end
end
