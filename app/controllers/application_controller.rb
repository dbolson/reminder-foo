class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_account
    Account.first
  end
end
