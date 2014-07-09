class SchedulesController < ApplicationController
  respond_to :html, :json

  def show
    # puts params.inspect
    # @events = Schedule.get_events(params[:year], params[:month])
    # respond_with @events
    render 'show'
  end

  def create
    puts params.inspect
    @events = Schedule.make_events(params[:schedule][:year].to_i, params[:schedule][:month].to_i)
    flash[:notice] = "Scheduling job was successfully submitted"
    redirect_to root_path
  end
end