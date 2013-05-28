FactoryGirl.define do
  factory :event do
    sequence(:name ) { |n| "event  #{n}" }
    description { Faker::Lorem.sentence }
    due_at { 10.days.from_now }

    trait :with_account do
      association :account, factory: :account
    end

    trait :with_event_list do
      association :event_list, factory: :event_list_with_account
    end

    factory :event_with_associations, traits: [:with_account, :with_event_list]
  end
end
