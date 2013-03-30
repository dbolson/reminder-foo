require 'spec_helper'

describe EventListsController do
  render_views

  context 'json' do
    describe '#index' do
    end

    describe '#show' do
      def do_action(id)
        get :show, id: id, format: :json
      end

      context 'with a valid id' do
        let(:record) { FactoryGirl.create(:event_list) }

        it 'is successful' do
          do_action(record.id)
          response.status.should == 200
        end

        it 'is a json response' do
          do_action(record.id)
          response.header['Content-Type'].should include('application/json')
        end

        it 'displays the attributes of the record' do
          do_action(record.id)
          body = JSON.parse(response.body)
          body['id'].should == record.id
          body['name'].should == record.name
        end
      end

      context 'with an invalid id' do
        it 'is unsuccessful' do
          expect {
            do_action(-1)
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
