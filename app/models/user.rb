class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, omniauth_providers: [:facebook, :twitter, :github, :linkedin, :google_oauth2]
  validates_presence_of :email
  
  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    identity = Identity.find_for_oauth(auth)
    if identity.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.email = auth.info.email
       user.email = auth.provider == "twitter" ?  set_dummy_twitter_email(auth.info.name, auth.uid.to_s) :  auth.info.email
       user.save
     end
     identity.name = auth.info.nickname
     identity.user = user
     identity.save
   end
   identity.user
 end       

 private

 def self.set_dummy_twitter_email(name, uid)
    "#{name}_#{uid}@twitter.com".gsub(' ', '_')
  end
end
