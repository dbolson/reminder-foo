require 'spec_helper'

describe Api::V1::Events::RemindersController do
  render_views

  let(:account) { create(:account) }
  let(:event) { create(:event, :with_event_list, account: account) }

  before do
    ApiKey.stub(:find_by_access_token).and_return(stub(:api_token, account: account))
  end

  describe '#create' do
    context 'with invalid params' do
      it 'displays errors' do
        post :create, event_id: event.id, reminder: { reminded_at: nil }, format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Reminded at can't be blank")
      end

      it 'has a 422 status' do
        post :create, event_id: event.id, reminder: { reminded_at: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe '#update' do
    context 'with invalid params' do
      let(:reminder) { create(:reminder, event: event) }

      it 'displays the errors' do
        put :update,
            event_id: event.id,
            id: reminder.id,
            reminder: { reminded_at: nil },
            format: :json
        response_body = JSON.parse(response.body)
        expect(response_body['errors']).to include("Reminded at can't be blank")
      end

      it 'has a 422 status' do
        put :update,
            event_id: event.id,
            id: reminder.id,
            reminder: { reminded_at: nil },
            format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
