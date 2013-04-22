require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Event List' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  def authenticate
    ApiKey.stub(:find_by_access_token)
      .and_return(stub(:api_token, account: account))
  end

  let(:account) { FactoryGirl.create(:account) }

  before do
    Timecop.freeze(2000, 1, 1)
    authenticate
  end

  get '/api/v1/event_lists' do
    let!(:event_list1) {
      create(:event_list,
             id: '1',
             name: 'event list 1',
             account: account)
    }
    let!(:event_list2) {
      create(:event_list,
             id: '2',
             name: 'event list 2',
             account: account)
    }
    let(:body) { JSON.parse(response_body) }

    example_request 'find all event lists' do
      expect(status).to eq(200)

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
        ],
        'status' => 200
      })
    end
  end

  get '/api/v1/event_lists/1' do
    let!(:event_list) {
      FactoryGirl.build_stubbed(:event_list, id: '1',
                                name: 'event list',
                                updated_at: Time.zone.now)
    }
    let(:event_lists) { stub(:event_lists) }
    let(:account) { stub(:account, event_lists: event_lists) }
    let(:body) { JSON.parse(response_body) }

    before do
      event_lists.stub(:find).with('1').and_return(event_list)
    end

    example_request 'find an event list' do
      expect(status).to eq(200)

      expect(body).to eq({
        'event_list' => {
            'id' => 1,
            'name' => 'event list',
            'created_at' => '2000-01-01T00:00:00Z',
            'updated_at' => '2000-01-01T00:00:00Z'
          },
        'status' => 200
      })
    end
  end

  post '/api/v1/event_lists/' do
  end
end
