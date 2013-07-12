module API
  class BaseV1 < Grape::API
    def self.inherited(subclass)
      super

      subclass.instance_eval do
        helpers API::BaseV1::Authentication
        helpers API::BaseV1::Representation
        helpers API::BaseV1::Responses

        http_basic do |username, password|
          ::APIKey.where(access_token: username).exists?
        end

        version 'v1', using: :path
        format :json

        rescue_from ActiveRecord::RecordNotFound do |e|
          message = e.message.gsub(/\s*\[.*\Z/, '')
          Rack::Response.new(
            [{ status: 404, status_code: 'not_found', error: message }.to_json],
            404
          )
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          message = e.message.downcase.capitalize
          Rack::Response.new(
            [{ status: 422, status_code: 'record_invalid', error: message }.to_json],
            422
          )
        end

        rescue_from Grape::Exceptions::Validation do |e|
          message = e.message.downcase.capitalize
          Rack::Response.new(
            [{ status: 422, status_code: 'record_invalid', error: message }.to_json],
            422
          )
        end
      end
    end

    module Authentication
      def current_account
        api_key = ::APIKey.find_by_access_token(env['REMOTE_USER'])
        if api_key.nil?
          @current_account = nil
        else
          @current_account ||= api_key.account
        end
      end

      def authenticate!
        error!({ status: 401, status_code: 'unauthorized' }, 401) unless current_account
      end
    end

    module Representation
      def represent(resource)
        BaseRepresenter.represent(resource, env)
      end

      def represent_collection(collection)
        BaseRepresenter.represent_collection(collection, env)
      end
    end

    module Responses
      def no_content!
        throw :error, message: nil, status: 204
      end
    end
  end
end
