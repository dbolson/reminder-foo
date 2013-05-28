require 'spec_helper'

describe Api::V1::EventsController do
  render_views

  let(:account) { create(:account) }

  before do
    ApiKey.stub(:find_by_access_token).and_return(stub(:api_token, account: account))
  end

  describe '#update' do
    context 'with errors' do
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
