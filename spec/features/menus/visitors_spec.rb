require 'spec_helper'

feature 'Visitor Menu Display', :devise do

  scenario 'visitor sees signin and signup links' do
    visit root_path
    expect(page).to have_selector(:link_or_button, 'Sign in')
    expect(page).to have_selector(:link_or_button, 'Sign up')
  end

  scenario 'visitor does not see Calendar, Users, Sign out, Events, Edit account, Edit profile links' do
    visit root_path
    expect(page).not_to have_selector(:link_or_button, 'Sign out')
    expect(page).not_to have_selector(:link_or_button, 'Calendar')
    expect(page).not_to have_selector(:link_or_button, 'Users')
    expect(page).not_to have_selector(:link_or_button, 'Events')
    expect(page).not_to have_selector(:link_or_button, 'Edit profile')
    expect(page).not_to have_selector(:link_or_button, 'Edit account')
  end
end
