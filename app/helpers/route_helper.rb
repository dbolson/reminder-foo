module RouteHelper
  def account_url(env)
    "#{RouteBuilder.new(env).base_url}/accounts"
  end

  def event_lists_url(env)
    "#{RouteBuilder.new(env).base_url}/event_lists"
  end

  def event_list_url(env, id)
    "#{event_lists_url(env)}/#{id}"
  end

  def subscribers_url(env)
    "#{RouteBuilder.new(env).base_url}/subscribers"
  end

  def subscriber_url(env, id)
    "#{subscribers_url(env)}/#{id}"
  end

  def event_url(env, event_list_id, id)
    "#{event_lists_url(env)}/#{event_list_id}/events/#{id}"
  end

  def reminders_url(env, event_id)
    "#{RouteBuilder.new(env).base_url}/events/#{event_id}/reminders"
  end

  def reminder_url(env, event_id, id)
    "#{reminders_url(env, event_id)}/#{id}"
  end

  class RouteBuilder
    def initialize(env)
      @env = env
    end

    def base_url
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}/api/#{env['api.version']}"
    end

    private

    attr_reader :env
  end
end
