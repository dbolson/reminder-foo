require 'spec_helper'

describe Request do
  describe 'with relationships' do
    it { should belong_to(:account) }
    it { should belong_to(:api_key) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:account) }
    it { should validate_presence_of(:api_key) }
    it { should validate_presence_of(:ip_address) }
    it { should validate_presence_of(:url) }
  end

  describe '#params' do
    it 'serializes as json' do
      request = create(:request_with_associations, params: { 'param' => 'my+param' })
      expect(request.params.to_json).to eq("{\"param\":\"my+param\"}")
    end
  end

  describe '.log' do
    let(:account) { build_stubbed(:account, api_key: api_key) }
    let(:api_key) { build_stubbed(:api_key) }

    let(:params) {{
      account: account,
      url: 'example.com?param=my+param',
      ip_address: '0.0.0.0',
      params: {
        'controller' => 'resources',
        'action' => 'show',
        'param' => 'my+param'
      }
    }}
    let(:request) { Request.log(params) }

    it 'logs the account' do
      expect(request.account).to eq(account)
    end

    it 'logs the api key' do
      expect(request.api_key).to eq(api_key)
    end

    it 'logs the url' do
      expect(request.url).to eq('example.com?param=my+param')
    end

    it 'logs the ip address' do
      expect(request.ip_address).to eq('0.0.0.0')
    end

    context 'with extra params' do
      it 'logs the extra params without the rails defaults' do
        expect(request.params).to eq('param' => 'my+param')
      end
    end

    context 'without extra params' do
      it 'does not log them' do
        params[:params] = {}
        request = Request.log(params)
        expect(request.params).to eq({})
      end
    end
  end
end
