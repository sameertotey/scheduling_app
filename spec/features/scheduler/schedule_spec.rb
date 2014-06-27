require 'spec_helper'

feature 'Receive schedule for a month' do

  scenario 'visitor receives authentication require message' do
    year = 2014
    month = 8
    visit "/schedule/2014/08.json"
    expect(page).to have_content "You need to sign in or sign up before continuing"
  end


  scenario 'signed in user can request schedule for a year and month' do  
    user = FactoryGirl.create(:admin)
    signin(user.email, user.password)
    year = 2014
    month = 8
    visit "/schedule/2014/08.json"
  end
end
