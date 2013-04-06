require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Event List' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get '/api/v1/event_lists' do
    let(:record_type) { EventList }
    let!(:record1) {
      FactoryGirl.build_stubbed(:event_list, id: '1', name: 'event list 1')
    }
    let!(:record2) {
      FactoryGirl.build_stubbed(:event_list, id: '2', name: 'event list 2')
    }

    before do
      authenticate
      record_type.stub(:all) { [record1, record2] }
    end

    example_request 'get a list of all event lists' do
      status.should == 200
      body = JSON.parse(response_body)
      body.should include({ 'event_list' => { 'id' => 1, 'name' => 'event list 1' }})
      body.should include({ 'event_list' => { 'id' => 2, 'name' => 'event list 2' }})
    end
  end
end
