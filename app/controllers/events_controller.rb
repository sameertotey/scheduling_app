class EventsController < ApplicationController
  before_filter :authenticate_user! 
  respond_to :json

  def index
    @events = Event.all
  end

  def create
    @event = Event.new
    @event.user = current_user
    @event.event_type = get_event_type
    if @event.update_attributes event_params
      render "events/show"
    else
      respond_with @event
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
    if @event.update_attributes event_params
      render "events/show"
    else
      respond_with @event
    end
  end

  private

  def event_params
    params.require(:event).permit(:date, :comment, :shift)
  end

  def get_event_type

  end
end
