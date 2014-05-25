# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    user nil
    date "2014-05-24"
    shift 1
    comment "My Event"
    event_type nil
  end
end
