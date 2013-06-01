require 'spec_helper'

describe Api::V1::AccountsController do
  render_views

  let(:account) { create(:account) }

  before do
    ApiKey.stub(:find_by_access_token)
      .and_return(stub(:api_token, account: account))
  end

  describe '#update' do
    context 'with invalid params' do
      it 'displays the errors' do
        put :update, id: account.id, account: { email: nil }, format: :json
        expect(JSON.parse(response.body)).to include({
          'errors' => ["Email can't be blank", 'Email is invalid']
        })
      end

      it 'has a 422 status' do
        put :update, id: account.id, account: { email: nil }, format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
