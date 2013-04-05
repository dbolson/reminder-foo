def authenticate
  ApiKey.stub(:find_by_access_token) { stub }
end
