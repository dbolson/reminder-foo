require 'spec_helper'

class MockController < Api::ApiController; end

describe Api::ApiController do
  controller(MockController) do
    def index
      render nothing: true
    end
  end

  let(:account) { stub(:account) }
  let(:api_key) { stub(:api_key, account: account) }

  context '#restrict_access' do
    context 'with a valid api key' do
      before do
        ApiKey.stub(:find_by_access_token).with('valid token').and_return(api_key)
        controller.stub(:log_request)
      end

      it 'allows access' do
        get :index, access_token: 'valid token'
        expect(response.status).to eq(200)
      end

      it 'sets the current account' do
        get :index, access_token: 'valid token'
        expect(controller.send(:current_account)).to eq(account)
      end
    end

    context 'with an invalid api key' do
      it 'prevents access' do
        ApiKey.stub(:find_by_access_token).with('invalid token').and_return(nil)
        get :index, access_token: 'invalid token'
        expect(response.status).to eq 401
      end
    end

    context 'without an api key' do
      it 'prevents access' do
        ApiKey.stub(:find_by_access_token).and_return(nil)
        get :index
        expect(response.status).to eq(401)
      end
    end
  end

  describe '#log_request' do
    before do
      ApiKey.stub(:find_by_access_token).with('valid token').and_return(api_key)
    end

    it 'logs the request' do
      Request.should_receive(:log).
        with(account: account,
             url: 'http://test.host/anonymous?access_token=valid+token&param=my+param',
             ip_address: '0.0.0.0',
             params: {
               'access_token' => 'valid token',
               'controller' => 'anonymous',
               'action' => 'index',
               'param' => 'my param'
             })

      get :index, access_token: 'valid token', 'param' => 'my param'
    end
  end
end
