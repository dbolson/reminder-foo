FactoryGirl.define do
  factory :subscriber do
    phone_number { "+1#{rand.to_s[2..11]}" }

    trait :with_account do
      association :account
    end
  end
end
