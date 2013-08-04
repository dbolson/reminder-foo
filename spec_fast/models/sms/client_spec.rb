require_relative '../../fast_spec_helper'
require_relative '../../../app/models/sms/client'

describe SMS::Client do
  describe '#create_message' do
    it 'sends a message to the phone number' do
      sms_client = double(:client)
      sms_message = double(:message)
      sms_client.stub_chain(:account, :sms, :messages).and_return(sms_message)

      sms_message.should_receive(:create).with({
        from: '14155555555',
        to: '+15555555555',
        body: 'my message'
      })

      client = SMS::Client.new
      client.sms_client = sms_client
      client.create_message({
        phone_number: '+15555555555',
        message: 'my message'
      })
    end

    context 'without a phone number' do
      it 'raises an exception' do
        expect {
          SMS::Client.create_message({ message: 'my message' })
        }.to raise_error(SMS::Client::InvalidArgumentError,
                         'Please provide a phone number in the form +15555555555')
      end
    end

    context 'with an invalid phone number' do
      it 'raises an exception' do
        expect {
          SMS::Client.create_message({ phone_number: '5555555555' })
        }.to raise_error(SMS::Client::InvalidArgumentError,
                         'Please provide a phone number in the form +15555555555')
      end
    end

    context 'without a message' do
      it 'raises an exception' do
        expect {
          SMS::Client.create_message({ phone_number: '+15555555555' })
        }.to raise_error(SMS::Client::InvalidArgumentError, 'Please provide a message')
      end
    end
  end
end
