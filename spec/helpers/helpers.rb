module AuthenticationHelpers
  def grant_access
    authenticate
    stub_logging
  end

  def authenticate
    APIKey.stub(:find_by_access_token).and_return(stub(:api_token, account: account))
  end

  def stub_logging
    Request.stub(:log)
    Response.stub(:log)
  end

  def http_authorize
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('valid token', nil)
  end
end

module DescribeHelpers
  def host
    'https://localhost:3000'
  end
end
