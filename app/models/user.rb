class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, omniauth_providers: [:facebook, :twitter, :github, :linkedin, :google_oauth2]
  validates_presence_of :email
  has_one :identity
  after_save :identity_setup
  
  def self.from_omniauth(auth, current_user)
    identity = Identity.find_for_oauth(auth)
    if identity.user.blank?
      user = User.where('email = ?', auth["info"]["email"]).first
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0,10]
        user.email = auth.provider == "twitter" ?  set_dummy_twitter_email(auth.info.name, auth.uid.to_s) :  auth.info.email
      end
      identity.user = user
      identity.save
      user.save
    end
    identity.user
  end       

  private

  def self.set_dummy_twitter_email(name, uid)
    "#{name}_#{uid}@twitter.com".gsub(' ', '_')
  end

  def identity_setup
    if self.identity.blank?
      # binding.pry
      self.identity = Identity.find_or_create_by(provider: "App_generated", uid: self.email)
    end
  end
end
