module API
  module V1
    class AccountsController < API::APIController
      respond_to :json, :xml

      def show
        @account = @current_account
      end
    end
  end
end
