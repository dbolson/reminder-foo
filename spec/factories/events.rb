FactoryGirl.define do
  factory :event do
    association :account
    association :event_list
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    due_at { 10.days.from_now }
  end
end
