require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Event List' do
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

  get '/api/v1/event_lists' do
    let!(:event_list1) {
      create(:event_list,
             id: 1,
             name: 'event list 1',
             account: account)
    }
    let!(:event_list2) {
      create(:event_list,
             id: 2,
             name: 'event list 2',
             account: account)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find all event lists' do
      expect(body).to eq({
        'event_lists' => [
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
        ]
      })

      expect(status).to eq(200)
    end
  end

  get '/api/v1/event_lists/1' do
    let!(:event_list) {
      create(:event_list, id: 1, name: 'event list', account: account)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find an event list' do
      expect(body).to eq({
        'event_list' => {
          'id' => 1,
          'name' => 'event list',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      })

      expect(status).to eq(200)
    end
  end

  post '/api/v1/event_lists/' do
    parameter :name, 'Name of event list'
    required_parameters :name
    scope_parameters :event_list, [:name]

    let(:name) { 'new event list' }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }
    let(:generated_id) { body['event_list']['id'] }

    example_request 'create an event list' do
      expect(body).to eq(
        'event_list' => {
          'id' => generated_id,
          'name' => 'new event list',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      )

      expect(status).to eq(201)
    end
  end

  put '/api/v1/event_lists/1' do
    parameter :name, 'Name of event list'
    required_parameters :name
    scope_parameters :event_list, [:name]

    let!(:event_list) {
      create(:event_list, id: 1, name: 'event list', account: account)
    }
    let(:name) { 'new event list name' }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'updating an event list' do
      expect(body).to eq(
        'event_list' => {
          'id' => 1,
          'name' => 'new event list name',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      )

      expect(status).to eq(200)
    end
  end

  delete '/api/v1/event_lists/1' do
    let!(:event_list) {
      create(:event_list, id: 1, name: 'event list', account: account)
    }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'deleting an event list' do
      expect(body).to eq(
        'event_list' => {
          'id' => 1,
          'name' => 'event list',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z'
        }
      )

      expect(status).to eq(200)
    end
  end
end
