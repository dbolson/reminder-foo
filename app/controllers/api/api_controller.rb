module Api
  class ApiController < ApplicationController
    before_filter :restrict_access

    private

    attr_accessor :current_account

    def restrict_access
      api_key = ApiKey.find_by_access_token(params[:access_token])
      if api_key
        @current_account = api_key.account
      else
        head :unauthorized
      end
    end
  end
end
