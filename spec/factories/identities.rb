# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :identity do
    user nil
    provider "App"
    uid "application_uid"
    name "Test User"
    token "test token"
    secret "test secret"
  end
end
