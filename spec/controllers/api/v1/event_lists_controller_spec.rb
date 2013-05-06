require 'spec_helper'

describe Api::V1::EventListsController do
  render_views

  let(:account) { create(:account) }

  before do
    ApiKey.stub(:find_by_access_token)
      .and_return(stub(:api_token, account: account))
  end

  describe '#create' do
    context 'with errors' do
      it 'displays the errors' do
        post :create, event_list: { name: nil }, format: :json
        expect(JSON.parse(response.body))
          .to include({ 'errors' => ["Name can't be blank"] })
      end

      it 'has a 402 status' do
        post :create, event_list: { name: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe '#update' do
    context 'with errors' do
      let(:event_list) { create(:event_list, account: account) }

      it 'displays the errors' do
        put :update, id: event_list.id, event_list: { name: nil }, format: :json
        expect(JSON.parse(response.body))
          .to include({ 'errors' => ["Name can't be blank"] })
      end

      it 'has a 402 status' do
        put :update, id: event_list.id, event_list: { name: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
