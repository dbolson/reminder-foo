require 'spec_helper'

describe EventListsController do
  render_views

  context 'json' do
    describe '#index' do
    end

    describe '#show' do
      def do_action
        get :show, id: record.id, format: :json
      end

      let(:record) { FactoryGirl.create(:event_list) }

      it 'is successful' do
        do_action
        response.status.should == 200
      end

      it 'is a json response' do
        do_action
        response.header['Content-Type'].should include('application/json')
      end

      it 'displays the attributes of the record' do
        do_action
        body = JSON.parse(response.body)
        body['id'].should == record.id
        body['name'].should == record.name
      end
    end
  end
end
