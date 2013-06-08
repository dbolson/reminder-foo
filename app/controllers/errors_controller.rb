class ErrorsController < ApplicationController
  respond_to :json, :xml

  def not_found
    render json: { errors: error_message },
           status: :not_found
  end

  def internal_server_error
    render json: { errors: 'Internal server error. We have been notified of the problem.' },
           status: :internal_server_error
  end

  private

  def error_message
    env['action_dispatch.exception'].message.gsub(/\[.+\]/, '').strip
  end
end
