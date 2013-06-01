require 'spec_helper'

describe Api::V1::EventLists::EventsController do
  render_views

  let(:account) { create(:account) }
  let(:event_list) { create(:event_list, account: account) }

  before do
    ApiKey.stub(:find_by_access_token).and_return(stub(:api_token, account: account))
  end

  describe '#create' do
    context 'with no params' do
      it 'displays the errors' do
        post :create, event_list_id: event_list.id, format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Name can't be blank")
      end
    end

    context 'with empty params' do
      it 'displays the errors' do
        post :create, event_list_id: event_list.id, event: {}, format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Name can't be blank")
      end
    end

    context 'with invalid params' do
      it 'displays errors' do
        post :create, event_list_id: event_list.id, event: { name: nil }, format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Name can't be blank")
      end

      it 'has a 422 status' do
        post :create, event_list_id: event_list.id, event: { name: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe '#update' do
    context 'with invalid params' do
      let(:event) { create(:event, account: account, event_list: event_list) }

      it 'displays the errors' do
        put :update,
            event_list_id: event_list.id,
            id: event.id,
            event: { name: nil, description: nil, due_at: nil },
            format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Name can't be blank")
        expect(response_body['errors']).to include("Description can't be blank")
        expect(response_body['errors']).to include("Due at can't be blank")
      end

      it 'has a 422 status' do
        put :update,
            event_list_id: event_list.id,
            id: event.id,
            event: { name: nil, description: nil, due_at: nil },
            format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
