class SchedulesController < ApplicationController
  respond_to :html, :json

  def show
  end

  def create
    @events = Schedule.make_events(params[:schedule][:year].to_i, params[:schedule][:month].to_i)
    flash[:notice] = "Scheduling job was successfully submitted"
    redirect_to root_path
  end
end