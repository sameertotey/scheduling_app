class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!
  
  def all
    user = User.from_omniauth(auth_hash, current_user)
    if user.persisted?
      set_flash_message(:notice, :success, :kind => auth_hash['provider']) if is_navigational_format?
      sign_in_and_redirect(user)
    else
      session["devise.auth_hash"] = auth_hash
      redirect_to new_user_registration_url
    end
  end

  def failure
    #delegate to super.
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