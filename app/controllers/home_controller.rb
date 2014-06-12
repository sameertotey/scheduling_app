class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    gon.current_user = current_user
    gon.environment = Rails.env
    gon.event_types = EventType.all
  end
end