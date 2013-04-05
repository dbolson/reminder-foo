FactoryGirl.define do
  factory :api_key do
    access_token { Faker::Lorem.characters(2) }
  end
end
