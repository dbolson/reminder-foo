require 'spec_helper'

describe Response do
  subject { build_stubbed(:response) }

  describe 'with relationships' do
    it { should belong_to(:account) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:content_type) }
    it { should validate_presence_of(:body) }
  end

  describe '#body' do
    it 'serializes as json' do
      response = build(:response, :with_account, body: { 'id' => 1 })
      expect(response.body.to_json).to eq("{\"id\":1}")
    end
  end

  describe '.log' do
    let(:account) { build_stubbed(:account) }

    let(:params) {{
      account: account,
      status: 200,
      content_type: 'application/json',
      body: { 'id' => 1 }
    }}
    let(:response) { Response.log(params) }

    it 'logs the account' do
      expect(response.account).to eq(account)
    end

    it 'logs the status' do
      expect(response.status).to eq(200)
    end

    it 'logs the content type' do
      expect(response.content_type).to eq('application/json')
    end

    it 'logs the body' do
      expect(response.body).to eq({ 'id' => 1 })
    end
  end
end
