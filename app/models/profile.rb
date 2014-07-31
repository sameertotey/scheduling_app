class Profile < ActiveRecord::Base
  belongs_to :user
  scope :with_role, -> (role_name) { where(role: role_name)}

  def self.update_for_oauth(user, auth)

    profile = find_by( user: user)
    attributes = {
      first_name: auth["info"]["first_name"],
      last_name: auth["info"]["last_name"],
      description: auth["info"]["description"],
      phone: auth["info"]["phone"],
      location: auth["info"]["location"],
      # urls: auth["info"]["urls"],
      image_loc: auth["info"]["image"],
      role: "default",
      initials: "XX"}
    profile.update_attributes(attributes)
  end
end
