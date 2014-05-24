class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.find_for_oauth(auth)
    find_or_create_by(provider: auth["provider"], uid: auth["uid"].to_s) do |identity|
      identity.token  = auth["credentials"]["token"]
      identity.secret = auth["credentials"]["secret"]
      identity.name   = auth["info"]["name"]
    end
  end

end