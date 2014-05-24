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
  visit new_user_session_path
  click_on "Sign in with #{provider.titleize}"
end