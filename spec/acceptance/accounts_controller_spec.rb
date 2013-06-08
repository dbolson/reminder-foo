require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Account' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'Authorization', 'Basic'

  let(:account) { create(:account, id: 1) }

  before do
    Timecop.freeze(2000, 1, 1)
    grant_access
  end

  after do
    Timecop.return
  end

  get "#{host}/api/v1/accounts" do
    let(:body) { JSON.parse(response_body) }

    example_request 'find your account' do
      expect(body).to eq({
        'id' => 1,
        'email' => account.email,
        'created_at' => '2000-01-01T00:00:00Z',
        'updated_at' => '2000-01-01T00:00:00Z'
      })

      expect(status).to eq(200)
    end
  end
end
