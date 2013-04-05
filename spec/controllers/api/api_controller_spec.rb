require 'spec_helper'

class MockController < Api::ApiController; end

describe Api::ApiController do
  controller(MockController) do
    def index
      render nothing: true
    end
  end

  context 'with a valid api key' do
    it 'allows access' do
      ApiKey.stub(:find_by_access_token).with('valid token') { stub }
      get :index, access_token: 'valid token'
      response.status.should == 200
    end
  end

  context 'with an invalid api key' do
    it 'prevents access' do
      ApiKey.stub(:find_by_access_token).with('invalid token') { nil }
      get :index, access_token: 'invalid token'
      response.status.should == 401
    end
  end

  context 'without an api key' do
    it 'prevents access' do
      ApiKey.stub(:find_by_access_token) { nil }
      get :index
      response.status.should == 401
    end
  end
end
