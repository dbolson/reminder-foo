require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Event List' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', 'Basic'

  let(:account) { create(:account) }

  before do
    Timecop.freeze(2000, 1, 1)
    grant_access
  end

  after do
    Timecop.return
  end

  get "#{host}/api/v1/event_lists" do
    let!(:event_list1) { create(:event_list, id: 1, name: 'event list 1', account: account) }
    let!(:event_list2) { create(:event_list, id: 2, name: 'event list 2', account: account) }
    let(:body) { JSON.parse(response_body) }

    example_request 'find all event lists' do
      expect(body).to eq([
        {
          'id' => 2,
          'name' => 'event list 2',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        },
        {
          'id' => 1,
          'name' => 'event list 1',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      ])

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/event_lists/1" do
    let!(:event_list) { create(:event_list, id: 1, name: 'event list', account: account) }
    let(:body) { JSON.parse(response_body) }

    example_request 'find an event list' do
      expect(body).to eq({
        'id' => 1,
        'name' => 'event list',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/event_lists/1/subscribers" do
    let!(:event_list) { create(:event_list, account: account, id: 1) }
    let!(:subscriber1) { create(:subscriber, account: account, id: 1) }
    let!(:subscriber2) { create(:subscriber, account: account, id: 2) }
    let!(:subscription1) {
      create(:subscription, account: account, event_list: event_list, subscriber: subscriber1, id: 1)
    }
    let!(:subscription2) {
      create(:subscription, account: account, event_list: event_list, subscriber: subscriber2, id: 2)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find the subscribers for the event list' do
      expect(body).to eq({
        'id' => 1,
        'name' => event_list.name,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'subscribers' => [
          {
            'id' => 1,
            'phone_number' => subscriber1.phone_number,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          },
          {
            'id' => 2,
            'phone_number' => subscriber2.phone_number,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          }
        ]
      })

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/event_lists/1/subscriptions" do
    let!(:event_list) { create(:event_list, account: account, id: 1) }
    let!(:subscription1) {
      create(:subscription, account: account, event_list: event_list, id: 1)
    }
    let!(:subscription2) {
      create(:subscription, account: account, event_list: event_list, id: 2)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find the subscriptions for the event list' do
      expect(body).to eq({
        'id' => 1,
        'name' => event_list.name,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'subscriptions' => [
          {
            'id' => 1,
            'event_list_id' => 1,
            'subscriber_id' => subscription1.subscriber_id,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          },
          {
            'id' => 2,
            'event_list_id' => 1,
            'subscriber_id' => subscription2.subscriber_id,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          }
        ]
      })

      expect(status).to eq(200)
    end
  end

  post "#{host}/api/v1/event_lists" do
    parameter :name, 'Name of event list'
    required_parameters :name
    scope_parameters :event_list, [:name]

    let(:name) { 'new event list' }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }
    let(:generated_id) { body['id'] }

    example_request 'create an event list' do
      expect(body).to eq({
        'id' => generated_id,
        'name' => 'new event list',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })

      expect(status).to eq(201)
    end
  end

  put "#{host}/api/v1/event_lists/1" do
    parameter :name, 'Name of event list'
    required_parameters :name
    scope_parameters :event_list, [:name]

    let!(:event_list) { create(:event_list, account: account, id: 1) }
    let(:name) { 'new event list name' }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'update an event list' do
      expect(body).to eq({
        'id' => 1,
        'name' => 'new event list name',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })
      expect(status).to eq(200)
    end
  end

  delete "#{host}/api/v1/event_lists/1" do
    let!(:event_list) { create(:event_list, account: account, id: 1) }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'delete an event list' do
      expect(body).to eq({
        'id' => 1,
        'name' => event_list.name,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })

      expect(status).to eq(200)
    end
  end
end
