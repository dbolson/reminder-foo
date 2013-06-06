module Api
  class ApiController < ApplicationController
    before_filter :restrict_access
    before_filter :log_request
    after_filter :log_response

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

    def log_request
      Request.log(account: current_account,
                  url: request.original_url,
                  http_verb: request.method,
                  ip_address: request.remote_ip,
                  params: params)
    end

    def log_response
      Response.log(account: current_account,
                   status: response.status,
                   content_type: response.content_type.to_s,
                   body: JSON.parse(response.body))
    end
  end
end
