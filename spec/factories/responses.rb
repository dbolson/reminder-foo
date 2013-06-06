FactoryGirl.define do
  factory :response do
    status 200
    content_type 'application/json'
    body {{ 'id' => 1 }}

    trait :with_account do
      association :account
    end
  end
end
