require 'spec_helper'

describe 'sending sms reminders', :integration do
  before do
    Timecop.freeze(Time.local(2000, 1, 1))
  end

  after do
    Timecop.return
  end

  let(:account) { event_list1.account }
  let(:event_list1) { create(:event_list, :with_account) }
  let(:event_list2) { create(:event_list, account: account) }
  let(:event1) { create(:event, account: account, event_list: event_list1, due_at: 10.days.from_now) }
  let(:reminder1) { create(:reminder, event: event1, reminded_at: 10.minutes.ago) }
  let(:subscriber1) { create(:subscriber, account: account, phone_number: '15555555555') }

  context 'with a reminder due in the previous 10 minutes' do
    let(:reminder2) { create(:reminder, event: event2, reminded_at: 1.minute.ago) }
    let(:subscriber2) { create(:subscriber, account: account, phone_number: '15555555556') }
    let(:event2) { create(:event, account: account, event_list: event_list2, due_at: 20.days.from_now) }

    before do
      create(:subscription, account: account, event_list: event_list1, subscriber: subscriber1)
      create(:subscription, account: account, event_list: event_list1, subscriber: subscriber2)
      create(:subscription, account: account, event_list: event_list2, subscriber: subscriber1)
    end

    it 'sends the sms reminder' do
      SMS::Client.should_receive(:send_message).with({
        phone_number: '+15555555555',
        message: "#{reminder1.event.name} is due on 01-11"
      })
      SMS::Client.should_receive(:send_message).with({
        phone_number: '+15555555556',
        message: "#{reminder1.event.name} is due on 01-11"
      })
      SMS::Client.should_receive(:send_message).with({
        phone_number: '+15555555555',
        message: "#{reminder2.event.name} is due on 01-21"
      })
      SMSReminder.run
    end
  end

  context 'with an event due more than 10 minutes ago' do
    before do
      create(:reminder, event: event1, reminded_at: 11.minutes.ago)
      create(:subscription, account: account, event_list: event_list1, subscriber: subscriber1)
    end

    it 'does not send the sms reminder' do
      SMS::Client.should_not_receive(:send_message)
      SMSReminder.run
    end
  end

  context 'with an event due in the future' do
    before do
      create(:reminder, event: event1, reminded_at: 1.minute.from_now)
      create(:subscription, account: account, event_list: event_list1, subscriber: subscriber1)
    end

    it 'does not send the sms reminder' do
      SMS::Client.should_not_receive(:send_message)
      SMSReminder.run
    end
  end
end
