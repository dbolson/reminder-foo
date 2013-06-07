require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Subscriber' do
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

  get "#{host}/api/v1/subscribers" do
    let!(:subscriber1) {
      create(:subscriber, id: 1, phone_number: '15555555555', account: account)
    }
    let!(:subscriber2) {
      create(:subscriber, id: 2, phone_number: '16666666666', account: account)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find all subscribers' do
      expect(body).to eq([
        {
          'id' => 2,
          'phone_number' => '16666666666',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        },
        {
          'id' => 1,
          'phone_number' => '15555555555',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      ])

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/subscribers/1" do
    let!(:subscriber) { create(:subscriber, id: 1, account: account) }
    let(:body) { JSON.parse(response_body) }

    example_request 'find a subscriber' do
      expect(body).to eq({
        'id' => 1,
        'phone_number' => subscriber.phone_number,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/subscribers/1/event_lists" do
    let!(:subscriber) { create(:subscriber, account: account, id: 1) }
    let!(:event_list1) { create(:event_list, account: account, id: 1) }
    let!(:event_list2) { create(:event_list, account: account, id: 2) }
    let!(:subscription1) {
      create(:subscription, account: account, event_list: event_list1, subscriber: subscriber, id: 1)
    }
    let!(:subscription2) {
      create(:subscription, account: account, event_list: event_list2, subscriber: subscriber, id: 2)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find the event lists for the subscriber' do
      expect(body).to eq({
        'id' => 1,
        'phone_number' => subscriber.phone_number,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event_lists' => [
          {
            'id' => 1,
            'name' => event_list1.name,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          },
          {
            'id' => 2,
            'name' => event_list2.name,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          }
        ]
      })

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/subscribers/1/subscriptions" do
    let!(:subscriber) { create(:subscriber, account: account, id: 1) }
    let!(:subscription1) {
      create(:subscription, account: account, subscriber: subscriber, id: 1)
    }
    let!(:subscription2) {
      create(:subscription, account: account, subscriber: subscriber, id: 2)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find the subscriptions for the subscriber' do
      expect(body).to eq({
        'id' => 1,
        'phone_number' => subscriber.phone_number,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'subscriptions' => [
          {
            'id' => 1,
            'event_list_id' => subscription1.event_list_id,
            'subscriber_id' => 1,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          },
          {
            'id' => 2,
            'event_list_id' => subscription2.event_list_id,
            'subscriber_id' => 1,
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          }
        ]
      })

      expect(status).to eq(200)
    end
  end

  post "#{host}/api/v1/subscribers/" do
    parameter :phone_number, '15555555555'
    required_parameters :phone_number
    scope_parameters :subscriber, [:phone_number]

    let(:phone_number) { '15555555555' }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }
    let(:generated_id) { body['id'] }

    example_request 'create a subscriber' do
      expect(body).to eq({
        'id' => generated_id,
        'phone_number' => '15555555555',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })

      expect(status).to eq(201)
    end
  end

  put "#{host}/api/v1/subscribers/1" do
    parameter :phone_number, '15555555555'
    required_parameters :phone_number
    scope_parameters :subscriber, [:phone_number]

    let!(:subscriber) { create(:subscriber, id: 1, account: account) }
    let(:phone_number) { '16666666666' }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'update a subscriber' do
      expect(body).to eq({
        'id' => 1,
        'phone_number' => '16666666666',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })
      expect(status).to eq(200)
    end
  end

  delete "#{host}/api/v1/subscribers/1" do
    let!(:subscriber) { create(:subscriber, id: 1, account: account) }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'delete a subscriber' do
      expect(body).to eq({
        'id' => 1,
        'phone_number' => subscriber.phone_number,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })

      expect(status).to eq(200)
    end
  end
end
