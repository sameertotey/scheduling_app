require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!


# Feature: User delete
#   As a user
#   I want to delete my user profile
#   So I can close my account
feature 'User delete', :devise, js: true do

  before(:each) do
    Capybara.current_driver = :webkit
  end
  
  after(:each) do
    Warden.test_reset!
    Capybara.use_default_driver
  end

  # Scenario: User can delete own account
  #   Given I am signed in
  #   When I delete my account
  #   Then I should see an account deleted message
  scenario 'user can delete own account', :slow do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit edit_user_registration_path(user)
    page.accept_confirm do
      click_button 'Cancel my account'
    end
    expect(page).to have_content 'Bye! Your account was successfully cancelled. We hope to see you again soon.'
  end

end

