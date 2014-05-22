class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!
  
  def all
    p env["omniauth.auth"]
    user = User.from_omniauth(auth_hash, current_user)
    if user.persisted?
      flash[:notice] = "You are in..!!! Go to edit profile to see the status for the accounts"
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  def failure
    #handle you logic here..
    #and delegate to super.
    super
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :linkedin, :all
  alias_method :github, :all
  alias_method :passthru, :all
  alias_method :google_oauth2, :all
end