require 'spec_helper'

describe Api::V1::SubscribersController do
  render_views

  let(:account) { create(:account) }

  before do
    ApiKey.stub(:find_by_access_token).and_return(stub(:api_token, account: account))
  end

  describe '#create' do
    context 'with invalid params' do
      it 'displays the errors' do
        post :create, subscriber: { phone_number: nil }, format: :json
        expect(JSON.parse(response.body))
          .to include({ 'errors' => ["Phone number can't be blank"] })
      end

      it 'has a 422 status' do
        post :create, subscriber: { phone_number: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe '#update' do
    context 'with invalid params' do
      let(:subscriber) { create(:subscriber, account: account) }

      it 'displays the errors' do
        put :update,
          id: subscriber.id,
          subscriber: { phone_number: nil },
          format: :json
        expect(JSON.parse(response.body))
          .to include({ 'errors' => ["Phone number can't be blank"] })
      end

      it 'has a 422 status' do
        put :update,
          id: subscriber.id,
          subscriber: { phone_number: nil },
          format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
