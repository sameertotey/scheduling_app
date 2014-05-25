class Profile < ActiveRecord::Base
  belongs_to :user

  def self.create_for_oauth(user, auth)
    find_or_create_by( user: user) do |profile|
      profile.first_name   = auth["info"]["first_name"]
      profile.last_name    = auth["info"]["last_name"]
      profile.description  = auth["info"]["description"]
      profile.phone        = auth["info"]["phone"]
      profile.location     = auth["info"]["location"]
      profile.urls         = auth["info"]["urls"]
      profile.image_loc    = auth["info"]["image"]
      profile.role         = "default"
      profile.initials     = "XX"
    end
  end
end
