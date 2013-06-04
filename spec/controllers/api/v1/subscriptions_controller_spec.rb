require 'spec_helper'

describe Api::V1::SubscriptionsController do
  render_views

  let(:account) { create(:account) }

  before do
    grant_access
  end

  describe '#create' do
    context 'with no data' do
      it 'displays the errors' do
        post :create, subscription: {}, format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Event list can't be blank")
        expect(response_body['errors']).to include("Subscriber can't be blank")
      end
    end

    context 'with invalid data' do
      it 'displays the errors' do
        post :create, subscription: { event_list_id: nil, subscriber_id: nil }, format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Event list can't be blank")
        expect(response_body['errors']).to include("Subscriber can't be blank")
      end

      it 'has a 422 status' do
        post :create, subscription: { event_list_id: nil, subscriber_id: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
