FactoryGirl.define do
  factory :subscription do
    event_list { |s| s.association(:event_list, account: s.account) }
    subscriber { |s| s.association(:subscriber, account: s.account) }
  end

  trait :with_account do
    association :account
  end
end
