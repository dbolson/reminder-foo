FactoryGirl.define do
  factory :event_list do
    name { Faker::Lorem.word }

    trait :with_account do
      association :account, factory: :account
    end

    factory :event_list_with_account, traits: [:with_account]
  end
end
