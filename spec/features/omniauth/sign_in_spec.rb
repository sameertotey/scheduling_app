require 'spec_helper'

# Feature: Sign in
#   As a user
#   I want to sign in using my existing facebook account
#   So I can visit protected areas of the site
feature 'Sign in' do

  # Scenario: User cannot sign in if not registered
  #   Given I do not exist as a user
  #   When I sign in with valid credentials
  #   Then I see an invalid credentials message
  scenario 'user with same email will be created if not already registered' do
    provider = 'facebook'
    signin_with_omniauth(provider)
    expect(page).to have_content "Successfully authenticated from #{provider} account"
  end


end
