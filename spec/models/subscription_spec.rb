require 'spec_helper'

describe Subscription do
  let(:record_type) { Subscription }

  describe 'with relations' do
    it { should belong_to(:account) }
    it { should belong_to(:event_list) }
    it { should belong_to(:subscriber) }
  end

  describe 'with validations' do
    let(:account) { create(:account) }
    let(:event_list) { create(:event_list, account: account) }
    let(:subscriber) { create(:subscriber, account: account) }

    specify do
      existing = create(:subscription,
                        account: account,
                        event_list: event_list,
                        subscriber: subscriber)
      new_record = build(:subscription,
                         account: existing.account,
                         event_list: existing.event_list,
                         subscriber: existing.subscriber)
      new_record.should_not be_valid
      expect(new_record.errors[:event_list_id].size).to eq(1)
    end

    it { should validate_presence_of(:event_list_id) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe '.create_for_account' do
    let(:account) { create(:account) }
    let(:event_list) { create(:event_list, account: account) }
    let(:subscriber) { create(:subscriber, account: account) }

    context 'with an event list and subscriber with the same account' do
      it 'creates a subscription for that account' do
        subscription = record_type.
          create_for_account(account: account,
                             subscription: {
                               subscriber_id: subscriber.id,
                               event_list_id: event_list.id
                             })
        expect(subscription).to be_persisted
      end
    end

    context 'with an event list and subscriber with a different account' do
      let(:another_account) { create(:account) }

      it 'does not create a subscription' do
        subscription = record_type.
          create_for_account(account: another_account,
                             subscription: {
                               subscriber_id: subscriber.id,
                               event_list_id: event_list.id
                             })

        expect(subscription).to_not be_persisted
      end
    end
  end
end
