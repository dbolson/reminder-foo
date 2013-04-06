require 'spec_helper'

describe Api::V1::EventListsController do
  render_views

  let(:record_type) { EventList }

  context 'json' do
    before do
      authenticate
    end

    describe '#index' do
      def do_action
        get :index, format: :json
      end

      let!(:record1) do
        FactoryGirl.build_stubbed(:event_list, id: '1', name: 'fake 1')
      end
      let!(:record2) do
        FactoryGirl.build_stubbed(:event_list, id: '2', name: 'fake 2')
      end

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
        body.should include({ 'event_list' => { 'id' => 1, 'name' => 'fake 1' }})
        body.should include({ 'event_list' => { 'id' => 2, 'name' => 'fake 2' }})
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

        it 'is successful' do
          do_action('10')
          response.status.should == 200
        end

        it 'displays the attributes of the record' do
          do_action('10')
          body = JSON.parse(response.body)['event_list']
          body['id'].should == record.id
          body['name'].should == record.name
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
        let(:errors) { stub(:errors, any?: false) }

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
          body = JSON.parse(response.body)['event_list']
          body['id'].should == record.id
          body['name'].should == record.name
        end
      end

      context 'without valid parameters' do
        let(:params) {{ 'invalid' => 'params' }}
        let(:errors) { stub(:errors, any?: true, full_messages: 'message') }

        before do
          record_type.stub(:new).with(params) { record }
          record.stub(:save) { false }
          record.stub(:errors) { errors }
        end

        it 'is a bad request' do
          do_action(params)
          response.status.should == 422
        end

        it 'displays the errors' do
          do_action(params)
          body = JSON.parse(response.body)['event_list']
          body['errors'].should == 'message'
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
        let(:errors) { stub(:errors, any?: false) }

        before do
          record_type.stub(:find).with('10') { record }
          record.stub(:update_attributes).with(params) { true }
        end

        it 'is successful' do
          do_action(params)
          response.status.should == 200
        end

        it 'displays the record' do
          do_action(params)
          body = JSON.parse(response.body)['event_list']
          body['id'].should == record.id
          body['name'].should == record.name
        end
      end

      context 'with invalid parameters' do
        let(:params) {{ 'invalid' => 'params' }}
        let(:errors) { stub(:errors, any?: true, full_messages: 'message') }

        before do
          record_type.stub(:find).with('10') { record }
          record.stub(:update_attributes).with(params) { false }
          record.stub(:errors) { errors }
        end

        it 'is not modified' do
          do_action(params)
          response.status.should == 304
        end

        it 'displays errors' do
          do_action(params)
          body = JSON.parse(response.body)['event_list']
          body['errors'].should == 'message'
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

      it 'is successful' do
        do_action('10')
        response.status.should == 200
      end

      it 'displays the record' do
        do_action('10')
        body = JSON.parse(response.body)['event_list']
        body['id'].should == record.id
        body['name'].should == record.name
        body['destroyed?'].should be_true
      end
    end
  end
end
