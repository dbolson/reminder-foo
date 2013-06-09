require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Subscription' do
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

  post "#{host}/api/v1/subscriptions" do
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

  delete "#{host}/api/v1/subscriptions/1" do
    let!(:subscription) { create(:subscription, account: account, id: 1) }
    let(:raw_post) { params.to_json }

    example_request 'delete a subscription' do
      expect(status).to eq(204)
    end
  end
end
