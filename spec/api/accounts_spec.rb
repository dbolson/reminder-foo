require 'spec_helper'

describe API::Accounts, :api do
  let(:api_key) { create(:api_key) }
  let(:account) { api_key.account }
  let(:access_token) { api_key.access_token }

  describe 'GET show' do
    let(:verb) { :get }
    let(:path) { '/api/v1/accounts' }
    let(:params) {{}}

    it_behaves_like 'requires authentication'

    it_behaves_like 'successful response'

    it 'gets the account' do
      do_action(verb, path, access_token, params)
      expect(JSON.parse(response.body)).to eq(
        'id' => account.id,
        'email' => account.email,
        'updated_at' => format_time(account.updated_at),
        'created_at' => format_time(account.created_at),
        'links' => [{
          'rel' => 'self',
          'href' => 'https://test.host/api/v1/accounts'
        }]
      )
    end
  end
end
