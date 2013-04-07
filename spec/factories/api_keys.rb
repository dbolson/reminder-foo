FactoryGirl.define do
  factory :api_key do
    association :account
  end
end
