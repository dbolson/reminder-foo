require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Subscriber' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  def authenticate
    ApiKey.stub(:find_by_access_token)
      .and_return(stub(:api_token, account: account))
  end

  let(:account) { create(:account) }

  before do
    Timecop.freeze(2000, 1, 1)
    authenticate
  end

  after do
    Timecop.return
  end

  post '/api/v1/subscriptions/' do
    parameter :event_list_id, 1
    parameter :subscriber_id, 1

    required_parameters :event_list_id, :subscriber_id
    scope_parameters :subscription, [:event_list_id, :subscriber_id]

    let!(:subscriber) { create(:subscriber, account: account, id: 1) }
    let!(:event_list) { create(:event_list, account: account, id: 1, name: 'event list') }

    let(:event_list_id) { 1 }
    let(:subscriber_id) { 1 }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }
    let(:generated_id) { body['id'] }

    example_request 'create a subscription' do
      expect(body).to eq({
        'id' => generated_id,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event_list' => {
          'id' => 1,
          'name' => 'event list',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        },
        'subscriber' => {
          'id' => 1,
          'phone_number' => subscriber.phone_number,
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      })

      expect(status).to eq(201)
    end
  end

  delete '/api/v1/subscriptions/1' do
    let!(:subscription) { create(:subscription, account: account, id: 1) }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'delete a subscription' do
      expect(body).to eq({
        'id' => 1,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event_list' => {
          'id' => subscription.event_list_id,
          'name' => subscription.event_list.name,
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        },
        'subscriber' => {
          'id' => subscription.subscriber_id,
          'phone_number' => subscription.subscriber.phone_number,
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      })

      expect(status).to eq(200)
    end
  end
end
