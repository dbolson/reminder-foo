module Api
  module V1
    class AccountsController < Api::ApiController
      respond_to :json, :xml

      def show
        @account = @current_account
      end
    end
  end
end
