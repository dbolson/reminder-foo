module API
  class Root < Grape::API
    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

    format :json

    mount API::Accounts
    mount API::EventLists
    mount API::Events
    mount API::Reminders
    mount API::Subscribers

    add_swagger_documentation mount_path: '/resources',
                              api_version: 'v1',
                              markdown: true,
                              hide_documentation_path: true,
                              base_path: "#{Rails.application.config.base_path}/api"
  end
end
