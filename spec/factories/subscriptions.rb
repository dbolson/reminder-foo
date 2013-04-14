FactoryGirl.define do
  factory :subscription do
    trait :with_event_list do
      association :event_list, factory: :event_list
    end

    trait :with_subscriber do
      association :subscriber, factory: :subscriber_with_account
    end

    factory :subscription_with_associations,
      traits: [:with_event_list, :with_subscriber]
  end
end
