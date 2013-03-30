require 'spec_helper'

describe EventListsController do
  render_views

  context 'json' do
    describe '#index' do
    end

    describe '#show' do
      def get_action
        get :show, id: record.id, format: :json
      end

      let(:record) { FactoryGirl.create(:event_list) }

      it 'is successful' do
        get_action
        response.status.should == 200
      end

      it 'is a json response' do
        get_action
        response.header['Content-Type'].should include('application/json')
      end

      it 'displays the attributes of the record' do
        get_action
        JSON.parse(response.body)['id'].should == record.id
        JSON.parse(response.body)['name'].should == record.name
      end
    end
  end
end
