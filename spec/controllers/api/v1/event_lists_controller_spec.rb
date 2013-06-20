require 'spec_helper'

describe API::V1::EventListsController do
  render_views

  let(:account) { create(:account) }

  before do
    http_authorize
    grant_access
  end

  describe '#create' do
    context 'with invalid params' do
      it 'displays the errors' do
        post :create, event_list: { name: nil }, format: :json
        expect(JSON.parse(response.body)).to include({ 'errors' => ["Name can't be blank"] })
      end

      it 'has a 422 status' do
        post :create, event_list: { name: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe '#update' do
    context 'with invalid params' do
      let(:event_list) { create(:event_list, account: account) }

      it 'displays the errors' do
        put :update, id: event_list.id, event_list: { name: nil }, format: :json
        expect(JSON.parse(response.body)).to include({ 'errors' => ["Name can't be blank"] })
      end

      it 'has a 422 status' do
        put :update, id: event_list.id, event_list: { name: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
