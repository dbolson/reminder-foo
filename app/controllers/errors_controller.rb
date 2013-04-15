class ErrorsController < ApplicationController
  respond_to :json, :xml

  def not_found
    render json: { error: error_message, status: 404 },
           status: :not_found
  end

  private

  def error_message
    env['action_dispatch.exception'].message.gsub(/\[.+\]/, '').strip
  end
end
