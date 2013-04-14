FactoryGirl.define do
  factory :reminder do
    reminded_at { 10.days.from_now }

    trait :with_event do
      association :event, factory: :event_with_associations
    end

    factory :reminder_with_event, traits: [:with_event]
  end
end
