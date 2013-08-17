module SpecHelpers
  def do_action(verb, path, api_key, params)
    path = "https://test.host#{path}"
    public_send(verb, path, params, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64("#{api_key}:")}")
  end

  def format_time(time)
    time.to_i.to_s
  end
end
