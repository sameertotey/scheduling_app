class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless @user == current_user || current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

  def edit
    @user = User.find(params[:id])   
    unless @user == current_user || current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes user_params
      flash[:notice] = "#{@user.email} was successfully updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    flash[:notice] = "#{@user.email} deleted."
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:admin)
  end
end
