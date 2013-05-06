class ErrorsController < ApplicationController
  respond_to :json, :xml

  def not_found
    render json: { errors: error_message },
           status: :not_found
  end

  private

  def error_message
    env['action_dispatch.exception'].message.gsub(/\[.+\]/, '').strip
  end
end
