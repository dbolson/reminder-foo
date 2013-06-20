module API
  module V1
    class AccountsController < API::APIController
      def show
        @account = @current_account
      end
    end
  end
end
