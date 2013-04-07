require 'spec_helper'

describe Api::V1::EventListsController do
  render_views

  let(:event_lists) { stub(:event_lists) }
  let(:account) { stub(:account, event_lists: event_lists) }

  context 'json' do
    before do
      ApiKey.stub(:find_by_access_token) { stub(:api_token, account: nil) }
      controller.stub(:current_account) { account }
    end

    describe '#index' do
      def do_action
        get :index, format: :json
      end

      let!(:event_list1) {
        FactoryGirl.build_stubbed(:event_list, id: '1', name: 'fake 1')
      }
      let!(:event_list2) {
        FactoryGirl.build_stubbed(:event_list, id: '2', name: 'fake 2')
      }

      before do
        event_lists.stub(:all) { [event_list1, event_list2] }
      end

      it 'is successful' do
        do_action
        response.status.should == 200
      end

      it 'displays the event_lists' do
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
        let!(:event_list) { FactoryGirl.build_stubbed(:event_list, id: '10') }

        before do
          event_lists.stub(:find).with('10') { event_list }
        end

        it 'is successful' do
          do_action('10')
          response.status.should == 200
        end

        it 'displays the attributes of the event list' do
          do_action('10')
          body = JSON.parse(response.body)['event_list']
          body['id'].should == event_list.id
          body['name'].should == event_list.name
        end
      end
    end

    describe '#create' do
      def do_action(params)
        post :create, event_list: params, format: :json
      end

      let!(:event_list) { FactoryGirl.build_stubbed(:event_list) }

      context 'with valid parameters' do
        let(:params) {{ 'valid' => 'params' }}
        let(:errors) { stub(:errors, any?: false) }

        before do
          event_list.stub(:save) { true }
          event_lists.stub(:new)
            .with('valid' => 'params', 'account' => account) { event_list }
        end

        it 'is successful' do
          do_action(params)
          response.status.should == 200
        end

        it 'displays the event list' do
          do_action(params)
          body = JSON.parse(response.body)['event_list']
          body['id'].should == event_list.id
          body['name'].should == event_list.name
        end
      end

      context 'without valid parameters' do
        let(:params) {{ 'invalid' => 'params' }}
        let(:errors) { stub(:errors, any?: true, full_messages: 'message') }

        before do
          event_list.stub(:save) { false }
          event_list.stub(:errors) { errors }
          event_lists.stub(:new)
            .with('invalid' => 'params', 'account' => account) { event_list }
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

      let!(:event_list) { FactoryGirl.build_stubbed(:event_list, id: '10') }

      context 'with valid parameters' do
        let(:params) {{ 'valid' => 'params' }}
        let(:errors) { stub(:errors, any?: false) }

        before do
          event_lists.stub(:find).with('10') { event_list }
          event_list.stub(:update_attributes).with(params) { true }
        end

        it 'is successful' do
          do_action(params)
          response.status.should == 200
        end

        it 'displays the event list' do
          do_action(params)
          body = JSON.parse(response.body)['event_list']
          body['id'].should == event_list.id
          body['name'].should == event_list.name
        end
      end

      context 'with invalid parameters' do
        let(:params) {{ 'invalid' => 'params' }}
        let(:errors) { stub(:errors, any?: true, full_messages: 'message') }

        before do
          event_lists.stub(:find).with('10') { event_list }
          event_list.stub(:update_attributes).with(params) { false }
          event_list.stub(:errors) { errors }
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

      let!(:event_list) { FactoryGirl.build_stubbed(:event_list, id: '10') }

      before do
        event_lists.stub(:find).with('10') { event_list }
        event_list.should_receive(:destroy)
        event_list.stub(:destroyed?) { true }
      end

      it 'is successful' do
        do_action('10')
        response.status.should == 200
      end

      it 'displays the event list' do
        do_action('10')
        body = JSON.parse(response.body)['event_list']
        body['id'].should == event_list.id
        body['name'].should == event_list.name
        body['destroyed?'].should be_true
      end
    end
  end
end
