require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Event' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', 'Basic'

  let(:account) { create(:account) }
  let(:event_list) { create(:event_list, account: account, id: 1, name: 'event list') }

  before do
    Timecop.freeze(2000, 1, 1)
    grant_access
  end

  after do
    Timecop.return
  end

  get "#{host}/api/v1/events" do
    let!(:event1) {
      create(:event,
             event_list: event_list,
             account: account,
             id: 1,
             name: 'event 1',
             description: 'event description')
    }
    let!(:event2) {
      create(:event,
             event_list: event_list,
             account: account,
             id: 2,
             name: 'event 2',
             description: 'event description')
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find all events' do
      expect(body).to eq([
        {
          'id' => 2,
          'name' => 'event 2',
          'description' => 'event description',
          'due_at' => '2000-01-11T00:00:00Z',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
          'event_list' => {
            'id' => 1,
            'name' => 'event list',
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z',
          }
        },
        {
          'id' => 1,
          'name' => 'event 1',
          'description' => 'event description',
          'due_at' => '2000-01-11T00:00:00Z',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
          'event_list' => {
            'id' => 1,
            'name' => 'event list',
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z',
          }
        }
      ])

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/events/1" do
    let!(:event) {
      create(:event,
             event_list: event_list,
             account: account,
             id: 1,
             name: 'event 1',
             description: 'event description')
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find an event' do
      expect(body).to eq({
        'id' => 1,
        'name' => 'event 1',
        'description' => 'event description',
        'due_at' => '2000-01-11T00:00:00Z',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event_list' => {
          'id' => 1,
          'name' => 'event list',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
        }
      })

      expect(status).to eq(200)
    end
  end

  put "#{host}/api/v1/events/1" do
    parameter :name, 'Name of event'
    parameter :description, 'Description of event'
    parameter :due_at, 'Date event is due'
    required_parameters :name, :description, :due_at
    scope_parameters :event, [:name, :description, :due_at]

    let!(:event) {
      create(:event,
             event_list: event_list,
             account: account,
             id: 1,
             name: 'event 1',
             description: 'event description')
    }

    let(:name) { 'new event name' }
    let(:description) { 'new event description' }
    let(:due_at) { 20.days.from_now }

    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'update an event' do
      expect(body).to eq({
        'id' => 1,
        'name' => 'new event name',
        'description' => 'new event description',
        'due_at' => '2000-01-21T00:00:00Z',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event_list' => {
          'id' => 1,
          'name' => 'event list',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
        }
      })

      expect(status).to eq(200)
    end
  end

  delete "#{host}/api/v1/events/1" do
    let!(:event) {
      create(:event,
             event_list: event_list,
             account: account,
             id: 1,
             name: 'event name',
             description: 'event description')
    }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'deleting an event' do
      expect(body).to eq({
        'id' => 1,
        'name' => 'event name',
        'description' => 'event description',
        'due_at' => '2000-01-11T00:00:00Z',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event_list' => {
          'id' => 1,
          'name' => 'event list',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
        }
      })

      expect(status).to eq(200)
    end
  end
end
