require 'spec_helper'

describe Services::Sandbox, slow: true do
  describe '.populate' do
    context 'with no sandbox account' do
      xit 'creates an account' do
        Account.should_receive(:create!)
        Services::Sandbox.populate
      end

      it 'creates subscribers for the account' do
        expect {
          Services::Sandbox.populate
        }.to change(Subscriber, :count).by(3)
        #ap Account.all
        #ap Subscriber.all
        #ap EventList.all
        #ap Event.all
        #ap EventList.first.subscribers
      end

      it 'creates event lists for the account' do
        expect {
          Services::Sandbox.populate
        }.to change(EventList, :count).by(2)
      end

      it 'creates events for the first event list' do
        Services::Sandbox.populate
        expect(EventList.first.events.count).to eq(2)
        expect(EventList.last.events.count).to eq(0)
      end

      it 'creates reminders' do
        Services::Sandbox.populate
        expect(Event.first.reminders.count).to eq(2)
        expect(Event.last.reminders.count).to eq(1)
      end

      it 'creates subscriptions' do
        Services::Sandbox.populate
        expect(EventList.first.subscribers.count).to eq(2)
        expect(EventList.last.subscribers.count).to eq(1)
      end
    end

    context 'with an existing account' do
      let!(:existing_account) { create(:account, email: 'sandbox@reminderfoo.com') }

      it 'destroys the account to start over cleanly' do
        Services::Sandbox.populate
        expect(Account.all).to_not include(existing_account)
      end
    end
  end
end
