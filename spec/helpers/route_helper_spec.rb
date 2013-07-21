require_relative '../../app/helpers/route_helper'

class FakeResource
  include RouteHelper
end

describe RouteHelper do
  let(:resource) { FakeResource.new }
  let(:env) {
    {
      'rack.url_scheme' => 'https',
      'HTTP_HOST' => 'test.host',
      'api.version' => 'v1'
    }
  }

  describe '#account_url' do
    specify do
      expect(resource.account_url(env)).to eq('https://test.host/api/v1/accounts')
    end
  end

  describe '#event_lists_url' do
    specify do
      expect(resource.event_lists_url(env)).to eq('https://test.host/api/v1/event_lists')
    end
  end

  describe '#event_list_url' do
    specify do
      expect(resource.event_list_url(env, 1)).to eq('https://test.host/api/v1/event_lists/1')
    end
  end

  describe '#subscribers_url' do
    specify do
      expect(resource.subscribers_url(env)).to eq('https://test.host/api/v1/subscribers')
    end
  end

  describe '#subscriber_url' do
    specify do
      expect(resource.subscriber_url(env, 1)).to eq('https://test.host/api/v1/subscribers/1')
    end
  end

  describe '#event_url' do
    specify do
      expect(resource.event_url(env, 1, 2)).to eq('https://test.host/api/v1/event_lists/1/events/2')
    end
  end

  describe '#reminders_url' do
    specify do
      expect(resource.reminders_url(env, 1)).to eq('https://test.host/api/v1/events/1/reminders')
    end
  end

  describe '#reminder_url' do
    specify do
      expect(resource.reminder_url(env, 1, 2)).to eq('https://test.host/api/v1/events/1/reminders/2')
    end
  end
end
