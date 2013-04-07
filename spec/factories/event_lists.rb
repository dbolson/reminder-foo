FactoryGirl.define do
  factory :event_list do
    association :account
    name { Faker::Lorem.characters(5) }
  end
end
