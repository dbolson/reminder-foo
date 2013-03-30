FactoryGirl.define do
  factory :event_list do
    name { Faker::Lorem.characters(5) }
  end
end
