FactoryGirl.define do
  factory :subscription do
    association :account
    event_list { |s| s.association(:event_list, account: s.account) }
    subscriber { |s| s.association(:subscriber, account: s.account) }
  end
end
