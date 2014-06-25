require "spec_helper"
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!


describe "events json api", :type => :api do
  let(:user){FactoryGirl.create(:user)}
  let(:event){FactoryGirl.create(:event)}
  let(:event_type){FactoryGirl.create(:event_type)}
  let(:url) { "/events" }

  context "GET by visitor" do
    it "receives authenticatin message" do
      get "#{url}.json"
      expect(last_response.status).to eq 401
      expect(JSON.parse(last_response.body)["error"]).to match /You need to sign in or sign up before continuing/
    end
  end

  context "GET by signed in user" do
    it "receives events" do
      login_as(user, :scope => :user, :run_callbacks => false)
      event
      get "#{url}.json"
      events = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(events.first["id"]).to eq event.id
      expect(events.first["shift"]).to eq event.shift
      expect(events.first["comment"]).to eq event.comment
      expect(events.first["user"]["id"]).to eq event.user.id
    end

    it "GET specific event" do
      login_as(user, :scope => :user, :run_callbacks => false)
      event
      get "#{url}/#{event.id}.json"
      events = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(events["id"]).to eq event.id
      expect(events["shift"]).to eq event.shift
      expect(events["comment"]).to eq event.comment
      expect(events["user"]["id"]).to eq event.user.id
    end
  end

  context "PUT by signed in user" do
    it "updates events" do
      login_as(user, :scope => :user, :run_callbacks => false)
      event
      put "#{url}/#{event.id}.json", event: {
        id: event.id,
        comment: "the updated comment",
        shift: "2"
      }, event_type_id: event.event_type_id
      events = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(events["id"]).to eq event.id
      expect(events["shift"]).to eq 2
      expect(events["comment"]).to eq "the updated comment"
      expect(events["user"]["id"]).to eq event.user.id
    end
  end

  context "PUT error" do
    it "updates fails" do
      login_as(user, :scope => :user, :run_callbacks => false)
      event
      put "#{url}/#{event.id}.json", event: {
        id: event.id,
        comment: "the updated comment",
        shift: ""
      }, event_type_id: event.event_type_id
      expect(last_response.status).to eq 422
      expect(JSON.parse(last_response.body)["errors"]["shift"].first).to match "can't be blank"
    end
  end

  context "DELETE by signed in user" do
    it "updates events" do
      login_as(user, :scope => :user, :run_callbacks => false)
      event
      delete "#{url}/#{event.id}.json"
      expect(last_response.status).to eq 200
    end
  end

  context "POST by signed in user" do
    it "creates events" do
      login_as(user, :scope => :user, :run_callbacks => false)
      event_type
      post "#{url}.json", event: {
        date: "2014-05-14",
        comment: "the new comment",
        shift: "1",
        event_type_id: event_type.id
      }, event_type_id: event_type.id
      events = JSON.parse(last_response.body)
      expect(last_response.status).to eq 200
      expect(events["shift"]).to eq 1
      expect(events["comment"]).to eq "the new comment"
      expect(events["user"]["id"]).to eq user.id
      expect(events["event_type"]["id"]).to eq event_type.id
    end
  end

  context "POST error" do
    it "creates fails" do
      login_as(user, :scope => :user, :run_callbacks => false)
      event_type
      post "#{url}.json", event: {
        date: "2014-05-14",
        comment: "the new comment",
        shift: "",
        event_type_id: event_type.id
      }, event_type_id: event_type.id
      puts last_response.body
      events = JSON.parse(last_response.body)
      expect(last_response.status).to eq 422
      expect(JSON.parse(last_response.body)["errors"]["shift"].first).to match "can't be blank"
    end
  end
end