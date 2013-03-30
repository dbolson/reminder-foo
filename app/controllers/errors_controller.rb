class ErrorsController < ApplicationController
  respond_to :json, :xml

  def not_found
    puts "ErrorsController#not_found"
    render json: { error: env['action_dispatch.exception'].message },
           status: :not_found
  end
end
