class HolidaysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_authorization_for_action
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]

  def index
    @holidays = Holiday.all
  end

  def new
    @holiday = Holiday.new
  end

  def create
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      flash[:notice] = "#{@holiday.description} was successfully created"
      redirect_to holidays_path
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @holiday.update_attributes holiday_params
      flash[:notice] = "#{@holiday.description} was successfully updated."
      redirect_to holidays_path
    else
      render 'edit'
    end
  end

  def destroy
    @holiday.destroy!
    flash[:notice] = "#{@holiday.description} deleted."
    redirect_to holidays_path
  end

  private

  def set_holiday
    @holiday = Holiday.find(params[:id])
  end

  def holiday_params
    params.require(:holiday).permit(:day_str, :description)
  end

  def validate_authorization_for_action
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end
end
