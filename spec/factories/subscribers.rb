FactoryGirl.define do
  factory :subscriber do
    sequence(:phone_number) { |n| "1555555555#{n % 10}" }

    trait :with_account do
      association :account
    end
  end
end
