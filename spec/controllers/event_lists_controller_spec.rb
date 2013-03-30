require 'spec_helper'

describe EventListsController do
  render_views

  let(:record_type) { EventList }

  context 'json' do
    describe '#index' do
      def do_action
        get :index, format: :json
      end

      let(:record1) { stub(:event_list, id: '1', name: 'fake 1') }
      let(:record2) { stub(:event_list, id: '2', name: 'fake 2') }

      before do
        record_type.stub(:all) { [record1, record2] }
      end

      it 'is successful' do
        do_action
        response.status.should == 200
      end

      it 'displays the records' do
        do_action
        body = JSON.parse(response.body)
        body.should include('id' => '1', 'name' => 'fake 1')
        body.should include('id' => '2', 'name' => 'fake 2')
      end
    end

    describe '#show' do
      def do_action(id)
        get :show, id: id, format: :json
      end

      context 'with a valid id' do
        let!(:record) { FactoryGirl.build_stubbed(:event_list) }

        before do
          record_type.stub(:find).with(record.id.to_s) { record }
        end

        it 'is successful' do
          do_action(record.id)
          response.status.should == 200
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

    describe '#create' do
      def do_action(params)
        post :create, event_list: params, format: :json
      end

      let!(:record) { FactoryGirl.build_stubbed(:event_list) }

      context 'with valid parameters' do
        let(:params) {{ 'valid' => 'params' }}

        before do
          record_type.stub(:new).with(params) { record }
          record.stub(:save) { true }
        end

        it 'is successful' do
          do_action(params)
          response.status.should == 200
        end

        it 'displays the record' do
          do_action(params)
          body = JSON.parse(response.body)
          body['id'].should == record.id
          body['name'].should == record.name
        end
      end

      context 'without valid parameters' do
        let(:params) {{ 'invalid' => 'params' }}

        before do
          record_type.stub(:new).with(params) { record }
          record.stub(:save) { false }
          record.stub(:errors) {{'error' => 'message'}}
        end

        it 'is a bad request' do
          do_action(params)
          response.status.should == 400
        end

        it 'displays the errors' do
          do_action(params)
          body = JSON.parse(response.body)
          body['errors'].should == { 'error' => 'message' }
        end
      end
    end
  end
end
