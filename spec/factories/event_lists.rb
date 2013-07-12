FactoryGirl.define do
  factory :event_list do
    sequence(:name) { |n| "event list #{n}" }

    trait :with_account do
      association :account
    end

    factory :event_list_with_account, traits: [:with_account]
  end
end
