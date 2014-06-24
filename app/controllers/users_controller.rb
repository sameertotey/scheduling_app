class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :validate_authorization_for_action

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:notice] = "#{@user.email} was successfully updated."
      if @user == current_user
        redirect_to root_path
      else
        redirect_to @user
      end
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
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end
end
