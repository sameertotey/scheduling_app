require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Users admin', :devise do

  after(:each) do
    Warden.test_reset!
  end

  scenario 'admin users can sees users list' do
    user = FactoryGirl.create(:admin)
    login_as(user, scope: :user)
    visit users_path
    expect(page).to have_content user.email
  end

  scenario 'normal users get access denied message trying to view users' do
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    Capybara.current_session.driver.header 'Referer', root_path
    visit users_path
    expect(page).to have_content 'Access denied.'
  end

  scenario 'admin user can see details of own user account' do
    user = FactoryGirl.create(:admin)
    login_as(user, :scope => :user)
    visit user_path(user)
    expect(page).to have_content 'User'
    expect(page).to have_content user.email
  end

  scenario "admin user can see another user's account" do
    me = FactoryGirl.create(:admin)
    other = FactoryGirl.create(:user, email: 'other@example.com')
    login_as(me, :scope => :user)
    visit user_path(other)
    expect(page).to have_content 'other@example.com'
  end

  scenario 'normal users get access denied message trying to view account' do
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    Capybara.current_session.driver.header 'Referer', root_path
    visit user_path(user)
    expect(page).to have_content 'Access denied.'
  end

  scenario 'admin user can edit details of own user account' do
    user = FactoryGirl.create(:admin)
    login_as(user, :scope => :user)
    visit user_path(user)
    click_link('Edit')
    expect(page).to have_content 'Update User Information'
    expect(page).to have_content 'Admin'
    select('false', from: 'user_admin')
    click_button 'Update'
    expect(page).to have_content "#{user.email} was successfully updated."
  end

  scenario 'admin user can edit details of other user account' do
    me = FactoryGirl.create(:admin)
    other = FactoryGirl.create(:user, email: 'other@example.com')
    login_as(me, :scope => :user)
    visit user_path(other)
    click_link('Edit')
    expect(page).to have_content 'Update User Information'
    expect(page).to have_content 'Admin'
    select('false', from: 'user_admin')
    click_button 'Update'
    expect(page).to have_content "#{other.email} was successfully updated."
  end

  scenario 'admin user can delete user account' do
    me = FactoryGirl.create(:admin)
    other = FactoryGirl.create(:user, email: 'other@example.com')
    login_as(me, :scope => :user)
    visit user_path(other)
    click_link('Delete')
    expect(page).to have_content "#{other.email} deleted."
  end

end
