require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "please123"
    factory :admin do
      admin true
    end
  end
end
