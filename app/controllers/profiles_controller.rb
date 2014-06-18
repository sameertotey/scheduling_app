class ProfilesController < ApplicationController
  before_filter :authenticate_user! 
  respond_to :json

  def index
    @profile = Profile.find_by user_id: params[:user_id]
  end

  def show
    @profile = {}
  end
  
  def update
    logger.info "The params were: #{params}"
    @profile = Profile.find params[:id]
    if @profile.update_attributes profile_params
      render "profile/show"
    else
      respond_with @profile
    end
  end
  private

  def profile_params
    params.require(:profile).permit(:id, :first_name, :last_name, :initials, :css_class)
  end
end
