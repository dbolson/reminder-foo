FactoryGirl.define do
  factory :request do
    ip_address '127.0.0.1'
    sequence(:url) { |n| "https://local.com/api/v1/events/#{n}?access_token=abc-#{n}" }
    http_verb 'GET'

    trait :with_account do
      association :account
    end

    trait :with_api_key do
      association(:api_key) { |a| a.association(:api_key, account: a.account) }
    end

    factory :request_with_associations, traits: [:with_account, :with_api_key]
  end
end
