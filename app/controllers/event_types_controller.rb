class EventTypesController < ApplicationController
  before_filter :authenticate_user! 
  respond_to :json

  def index
    @eventtypes = EventType.all
  end

end
