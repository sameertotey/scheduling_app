class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :validate_authorization_for_action, only: [:show, :edit, :update, :destroy]


  def index
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:notice] = "#{@user.email} was successfully updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy!
    flash[:notice] = "#{@user.email} deleted."
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def validate_authorization_for_action
    unless @user == current_user || current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end
end
