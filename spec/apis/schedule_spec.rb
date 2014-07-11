require "spec_helper"
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!


describe "Schedule json api", :type => :api do
  let(:user){FactoryGirl.create(:user)}
  let(:event){FactoryGirl.create(:event)}
  let(:event_type){FactoryGirl.create(:event_type)}

  context "GET by visitor" do
    it "receives authenticatin message" do
      get "/schedule.json"
      expect(last_response.status).to eq 401
      expect(JSON.parse(last_response.body)["error"]).to match /You need to sign in or sign up before continuing/
    end
  end

  context "GET by signed in user" do
    it "receives events" do
      event.date = Date.new(2014, 8, 15)
      event.save
      login_as(user, :scope => :user, :run_callbacks => false)
      get "/schedule.json"
      events = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      puts "events: #{events.inspect}"
      # expect(events.first["id"]).to eq event.id
      # expect(events.first["shift"]).to eq event.shift
      # expect(events.first["comment"]).to eq event.comment
      # expect(events.first["user"]["id"]).to eq event.user.id
    end

  end
end