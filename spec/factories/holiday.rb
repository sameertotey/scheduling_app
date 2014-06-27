# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :holiday do
    day_str "12-25"
    description "December 25, Christmas"
  end
end
