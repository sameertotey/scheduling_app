class AppSettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_authorization_for_action
  before_action :set_app_settings, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @app_settings.update_attributes holiday_params
      flash[:notice] = "app settings was successfully updated."
      redirect_to app_settings_path
    else
      render 'edit'
    end
  end

  private

  def set_app_settings
    @app_settings = AppSetting.first
  end

  def holiday_params
    params.require(:app_setting).permit(:num_docs_friday, :max_num_full_days, 
                :max_initial_shifts, :friday_full_shift)
  end

  def validate_authorization_for_action
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end
end
