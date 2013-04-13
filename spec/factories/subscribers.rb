FactoryGirl.define do
  factory :subscriber do
    phone_number '+15555555555'

    trait :with_account do
      association :account, factory: :account
    end

    factory :subscriber_with_account, traits: [:with_account]
  end
end
