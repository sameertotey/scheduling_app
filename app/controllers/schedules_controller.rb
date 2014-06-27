class SchedulesController < ApplicationController
  respond_to :json

  def show
    puts params.inspect
    @events = Schedule.get_events(params[:year], params[:month])
    render 'list'
  end

  def create
    puts params.inspect
    @events = Schedule.make_events(params[:year], params[:month], current_user)
    render 'list'    
  end
end