require 'spec_helper'

describe Api::V1::EventsController do
  render_views

  let(:account) { create(:account) }

  before do
    http_authorize
    grant_access
  end

  describe '#update' do
    context 'with invalid params' do
      let(:event) { create(:event, :with_event_list, account: account) }

      it 'displays the errors' do
        put :update, id: event.id, event: { name: nil }, format: :json
        expect(JSON.parse(response.body)).to include({ 'errors' => ["Name can't be blank"] })
      end

      it 'has a 422 status' do
        put :update, id: event.id, event: { name: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
