require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!


feature 'User Menu Display', :devise do
  after(:each) do
    Warden.test_reset!
  end

  scenario 'signed in user does not see relevant links', js: true do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit root_path
    expect(page).not_to have_selector(:link_or_button, 'Sign in')
    expect(page).not_to have_selector(:link_or_button, 'Sign up')
    expect(page).not_to have_selector(:link_or_button, 'Users')
  end

  scenario 'signed in user sees appropriate links', js: true do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit root_path
    expect(page).to have_selector(:link_or_button, 'Sign out')
    expect(page).to have_selector(:link_or_button, 'Calendar')
    expect(page).to have_selector(:link_or_button, 'Events')
    expect(page).to have_selector(:link_or_button, 'Edit profile')
    expect(page).to have_selector(:link_or_button, 'Edit account')

  end

end
