# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    first_name   "test"
    last_name    "lastname"
    description  "desc"
    phone        "123-456-0789"
    location     "location"
    urls "http://www.sameertotey.com"
    image_loc     "my_image"
    role          "role"
    initials      "AB"  
    user          nil
  end
end
