class ErrorsController < ApplicationController
  respond_to :json, :xml

  def not_found
    render json: { errors: exception_message }, status: :not_found
  end

  def internal_server_error
    log_response
    render json: response_body, status: :internal_server_error
  end

  private

  def exception_message
    env['action_dispatch.exception'].message.gsub(/\[.+\]/, '').strip
  end

  def log_response
    Response.log(status: 500, content_type: 'application/json', body: response_body)
  end

  def response_body
    { errors: 'Internal server error. We have been notified of the problem.' }
  end
end
