FactoryGirl.define do
  factory :event_list do
    association :account
    name { Faker::Lorem.word }
  end
end
