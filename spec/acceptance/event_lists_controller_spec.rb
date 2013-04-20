require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Event List' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before do
    Timecop.freeze(2000, 1, 1)
  end

  get '/api/v1/event_lists' do
    let!(:event_list1) {
      FactoryGirl.build_stubbed(:event_list, id: '1', name: 'event list 1')
    }
    let!(:event_list2) {
      FactoryGirl.build_stubbed(:event_list, id: '2', name: 'event list 2')
    }

    let(:event_lists) { stub(:event_lists) }
    let(:account) { stub(:account, event_lists: event_lists) }

    before do
      ApiKey.stub(:find_by_access_token) { stub(:api_token, account: account) }
      event_lists.stub(:all) { [event_list1, event_list2] }
    end

    example_request 'get a list of all event lists' do
      status.should == 200
      body = JSON.parse(response_body)
      expect(body).to include({ 'event_list' => {
        'id' => 1, 'name' => 'event list 1' }
      })
      expect(body).to include({ 'event_list' => {
        'id' => 2, 'name' => 'event list 2' }
      })
    end
  end
end
