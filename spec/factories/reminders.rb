FactoryGirl.define do
  factory :reminder do
    sequence(:reminded_at) { |n| (n + 1).days.from_now }

    trait :with_event do
      association :event, factory: :event_with_associations
    end

    factory :reminder_with_event, traits: [:with_event]
  end
end
