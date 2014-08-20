require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!


feature 'Admin Menu Display', :devise do
  after(:each) do
    Warden.test_reset!
  end

  scenario 'signed in admin user does not see relevant links', js: true do
    user = FactoryGirl.create(:admin)
    login_as(user, :scope => :user)
    visit root_path
    print page.html
    expect(page).not_to have_selector(:link_or_button, 'Sign in')
    expect(page).not_to have_selector(:link_or_button, 'Sign up')
  end

  scenario 'signed in admin user sees appropriate links', js: true do
    user = FactoryGirl.create(:admin)
    login_as(user, :scope => :user)
    visit root_path
    expect(page).to have_selector(:link_or_button, 'Users')
    expect(page).to have_selector(:link_or_button, 'Sign out')
    expect(page).to have_selector(:link_or_button, 'Calendar')
    expect(page).to have_selector(:link_or_button, 'Events')
    expect(page).to have_selector(:link_or_button, 'Edit profile')
    expect(page).to have_selector(:link_or_button, 'Edit account')

  end

end
