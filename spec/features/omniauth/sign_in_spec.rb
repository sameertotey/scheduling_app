require 'spec_helper'

# Feature: Sign in
#   As a user
#   I want to sign in using my existing facebook/twitter/github/linked_in/google+ account
#   So I can visit protected areas of the site

feature 'Sign in with external accounts' do

  scenario 'user can signin/signout with external account' do  
    [:facebook, :twitter, :github, :linkedin, :google_oauth2].each do |account|
      provider = account.to_s
      signin_with_omniauth(provider)
      expect(page).to have_content "Successfully authenticated from #{provider} account"
      click_link 'Sign out'
      expect(page).to have_content 'Signed out successfully.'
    end
  end

  scenario 'user with same email will be created if not already registered' do
    expect(User.count).to eq 0
    expect(Profile.count).to eq 0

    expect(Identity.count).to eq 0
    provider = 'facebook'
    signin_with_omniauth(provider)
    expect(page).to have_content "Successfully authenticated from #{provider} account"
    expect(User.count).to eq 1
    expect(Profile.count).to eq 1
    expect(Identity.count).to eq 1
  end

  scenario 'user with same email will be reused if already registered' do
    expect(User.count).to eq 0
    expect(Identity.count).to eq 0
    provider = 'facebook'
    signin_with_omniauth(provider)
    expect(page).to have_content "Successfully authenticated from #{provider} account"
    click_link 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
    expect(User.count).to eq 1
    expect(Identity.count).to eq 1
    provider = 'github'
    signin_with_omniauth(provider)
    expect(page).to have_content "Successfully authenticated from #{provider} account"
    expect(User.count).to eq 1
    expect(Profile.count).to eq 1
    expect(Identity.count).to eq 2
  end

  scenario 'user with have autogenerated email if signing in with twitter' do
    expect(User.count).to eq 0
    expect(Identity.count).to eq 0
    provider = 'twitter'
    signin_with_omniauth(provider)
    expect(page).to have_content "Successfully authenticated from #{provider} account"
    expect(User.count).to eq 1
    expect(Profile.count).to eq 1
    expect(Identity.count).to eq 1
    expect(User.first.email).to eq "test_user_twt_uid@twitter.com"
  end

  scenario 'unsuccessful login from external account' do
    provider = 'facebook'
    signin_with_omniauth_fail(provider)
    expect(page).to have_content "Could not authenticate you from #{provider.titleize} because \"Invalid credentials\""
  end
end
