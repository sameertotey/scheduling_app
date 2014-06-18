class ProfilesController < ApplicationController
  before_filter :authenticate_user! 
  respond_to :json

  def index
    @profile = Profile.find_by user_id: params[:user_id]
  end

  def show
    @profile = {}
  end
  
end
