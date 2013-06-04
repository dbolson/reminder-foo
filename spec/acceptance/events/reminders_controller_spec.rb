require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Event' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  def event
    @event ||= create(:event, :with_event_list, account: account, id: 1, name: 'event')
  end

  let(:account) { create(:account) }

  before do
    Timecop.freeze(2000, 1, 1)
    grant_access
    event
  end

  after do
    Timecop.return
  end

  get "#{host}/api/v1/events/1/reminders" do
    let!(:reminder1) {
      create(:reminder,
             event: event,
             id: 1,
             reminded_at: 10.days.from_now)
    }
    let!(:event2) {
      create(:reminder,
             event: event,
             id: 2,
             reminded_at: 20.days.from_now)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find all reminders' do
      expect(body).to eq([
        {
          'id' => 1,
          'reminded_at' => '2000-01-11T00:00:00Z',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
          'event' => {
            'id' => 1,
            'name' => 'event',
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z',
          }
        },
        {
          'id' => 2,
          'reminded_at' => '2000-01-21T00:00:00Z',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
          'event' => {
            'id' => 1,
            'name' => 'event',
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z',
          }
        }
      ])

      expect(status).to eq(200)
    end
  end

  get "#{host}/api/v1/events/1/reminders/1" do
    let!(:reminder) {
      create(:reminder,
             event: event,
             id: 1,
             reminded_at: 10.days.from_now)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find a reminder' do
      expect(body).to eq({
        'id' => 1,
        'reminded_at' => '2000-01-11T00:00:00Z',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event' => {
          'id' => 1,
          'name' => 'event',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
        }
      })

      expect(status).to eq(200)
    end
  end

  post "#{host}/api/v1/events/1/reminders" do
    parameter :reminded_at, 'Date event is due'
    required_parameters :reminded_at
    scope_parameters :reminder, [:reminded_at]

    let(:reminded_at) { 10.days.from_now }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }
    let(:generated_id) { body['id'] }

    example_request 'update a reminder' do
      expect(body).to eq({
        'id' => generated_id,
        'reminded_at' => '2000-01-11T00:00:00Z',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event' => {
          'id' => 1,
          'name' => 'event',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
        }
      })

      expect(status).to eq(201)
    end
  end

  delete "#{host}/api/v1/events/1/reminders/1" do
    let!(:remidner) {
      create(:reminder,
             event: event,
             id: 1,
             reminded_at: 11.days.from_now)
    }
    let(:raw_post) { params.to_json }
    let(:body) { JSON.parse(response_body) }

    example_request 'deleting an event' do
      expect(body).to eq({
        'id' => 1,
        'reminded_at' => '2000-01-12T00:00:00Z',
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z',
        'event' => {
          'id' => 1,
          'name' => 'event',
          'created_at' => '2000-01-01T00:00:00Z',
          'updated_at' => '2000-01-01T00:00:00Z',
        }
      })

      expect(status).to eq(200)
    end
  end
end
