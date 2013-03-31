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

      it 'is successful', api_doc: true do
        do_action
        response.status.should == 200
      end

      it 'displays the records', api_doc: true do
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
        let!(:record) { FactoryGirl.build_stubbed(:event_list, id: '10') }

        before do
          record_type.stub(:find).with('10') { record }
        end

        it 'is successful', api_doc: true do
          do_action('10')
          response.status.should == 200
        end

        it 'displays the attributes of the record', api_doc: true do
          do_action('10')
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

        it 'is successful', api_doc: true do
          do_action(params)
          response.status.should == 200
        end

        it 'displays the record', api_doc: true do
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

        it 'is a bad request', api_doc: true do
          do_action(params)
          response.status.should == 400
        end

        it 'displays the errors', api_doc: true do
          do_action(params)
          body = JSON.parse(response.body)
          body['errors'].should == { 'error' => 'message' }
        end
      end
    end

    describe '#update' do
      def do_action(params)
        put :update, id: '10', event_list: params, format: :json
      end

      let!(:record) { FactoryGirl.build_stubbed(:event_list, id: '10') }

      context 'with valid parameters' do
        let(:params) {{ 'valid' => 'params' }}

        before do
          record_type.stub(:find).with('10') { record }
          record.stub(:update_attributes).with(params) { true }
        end

        it 'is successful', api_doc: true do
          do_action(params)
          response.status.should == 200
        end

        it 'displays the record', api_doc: true do
          do_action(params)
          body = JSON.parse(response.body)
          body['id'].should == record.id
          body['name'].should == record.name
        end
      end

      context 'with invalid parameters' do
        let(:params) {{ 'invalid' => 'params' }}

        before do
          record_type.stub(:find).with('10') { record }
          record.stub(:update_attributes).with(params) { false }
          record.stub(:errors) {{'error' => 'message'}}
        end

        it 'is not modified', api_doc: true do
          do_action(params)
          response.status.should == 304
        end

        it 'displays errors', api_doc: true do
          do_action(params)
          body = JSON.parse(response.body)
          body['errors'].should == { 'error' => 'message' }
        end
      end
    end

    describe '#destroy' do
      def do_action(id)
        delete :destroy, id: id, format: :json
      end

      let!(:record) { FactoryGirl.build_stubbed(:event_list, id: '10') }

      before do
        record_type.stub(:find).with('10') { record }
        record.should_receive(:destroy)
        record.stub(:destroyed?) { true }
      end

      it 'is successful', api_doc: true do
        do_action('10')
        response.status.should == 200
      end

      it 'displays the record', api_doc: true do
        do_action('10')
        body = JSON.parse(response.body)
        body['id'].should == record.id
        body['name'].should == record.name
        body['destroyed?'].should be_true
      end
    end
  end
end
