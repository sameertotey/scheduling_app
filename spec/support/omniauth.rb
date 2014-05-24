def signin_with_omniauth(provider)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:default] = {
      "provider" => "#{provider}",
      "uid" => "test uid",
      "info" => {"name"=>"test user",
                "email"=>"test@example.com"},
      "credentials" => {"token"=>"test token",
                        "secret"=>"test secret"}
  }
  OmniAuth.config.mock_auth[:twitter] = {
      "provider" => "#{provider}",
      "uid" => "twt uid",
      "info" => {"name"=>"test user"},
      "credentials" => {"token"=>"test token",
                        "secret"=>"test secret"}
  }

  OmniAuth.config.mock_auth[:twister] = :invalid_credentials

  visit new_user_session_path
  click_on "Sign in with #{provider.titleize}"
end

def signin_with_omniauth_fail(provider)
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:default] = :invalid_credentials

  visit new_user_session_path
  click_on "Sign in with #{provider.titleize}"
end