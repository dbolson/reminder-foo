FactoryGirl.define do
  factory :subscription do
    association :account
    association :event_list, factory: :event_list_with_account
    association :subscriber, factory: :subscriber_with_account
  end
end
