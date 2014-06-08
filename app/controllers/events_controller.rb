class EventsController < ApplicationController
  respond_to :json

  def index
    @events = Event.all
  end

end
