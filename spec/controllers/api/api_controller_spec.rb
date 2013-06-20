require 'spec_helper'

class MockController < API::APIController; end

describe API::APIController do
  controller(MockController) do
    def index
      render json: { rendered: 'text' }
    end
  end

  let(:account) { stub(:account) }
  let(:api_key) { stub(:api_key, account: account) }

  context '#restrict_access' do
    context 'with a valid api key' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('valid token', nil)
        APIKey.stub(:find_by_access_token).with('valid token').and_return(api_key)
        controller.stub(:log_request)
        controller.stub(:log_response)
      end

      it 'allows access' do
        get :index, format: :json
        expect(response.status).to eq(200)
      end

      it 'sets the current account' do
        get :index, format: :json
        expect(controller.send(:current_account)).to eq(account)
      end
    end

    context 'with an invalid api key' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('invalid token', nil)
      end

      it 'prevents access' do
        APIKey.stub(:find_by_access_token).with('invalid token').and_return(nil)
        get :index, format: :json
        expect(response.status).to eq(401)
      end
    end

    context 'without an api key' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(nil, nil)
      end

      it 'prevents access' do
        APIKey.stub(:find_by_access_token).and_return(nil)
        get :index, format: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe '#log_request' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('valid token', nil)
      APIKey.stub(:find_by_access_token).with('valid token').and_return(api_key)
      controller.stub(:log_response)
    end

    it 'logs the request' do
      Request.should_receive(:log).
        with(account: account,
             url: 'http://test.host/anonymous.json?param=my+param',
             http_verb: 'GET',
             ip_address: '0.0.0.0',
             params: {
               'param' => 'my param',
               'format' => 'json',
               'controller' => 'anonymous',
               'action' => 'index'
             })

      get :index, 'param' => 'my param', format: :json
    end
  end

  describe '#log_response' do
    before do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('valid token', nil)
      APIKey.stub(:find_by_access_token).with('valid token').and_return(api_key)
      Request.stub(:log)
    end

    it 'logs the response' do
      Response.should_receive(:log).
        with(account: account,
             status: 200,
             content_type: 'application/json',
             body: '{"rendered":"text"}')
      get :index, format: :json
    end
  end
end
