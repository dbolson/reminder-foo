require 'spec_helper'

class MockController < Api::ApiController; end

describe Api::ApiController do
  controller(MockController) do
    def index
      render nothing: true
    end
  end

  context 'with a valid api key' do
    let(:account) { stub(:account) }
    let(:api_key) { stub(:api_key, account: account) }

    before do
      ApiKey.stub(:find_by_access_token).with('valid token') { api_key }
    end

    it 'allows access' do
      get :index, access_token: 'valid token'
      expect(response.status).to eq 200
    end

    it 'sets the current account' do
      get :index, access_token: 'valid token'
      expect(controller.send(:current_account)).to eq account
    end
  end

  context 'with an invalid api key' do
    it 'prevents access' do
      ApiKey.stub(:find_by_access_token).with('invalid token') { nil }
      get :index, access_token: 'invalid token'
      expect(response.status).to eq 401
    end
  end

  context 'without an api key' do
    it 'prevents access' do
      ApiKey.stub(:find_by_access_token) { nil }
      get :index
      expect(response.status).to eq 401
    end
  end
end
