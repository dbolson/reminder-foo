module Api
  module V1
    class AccountsController < Api::ApiController
      respond_to :json, :xml

      def show
        @account = @current_account
      end

      def update
        @account = @current_account

        if @account.update_attributes(params[:account])
          render 'update'
        else
          render 'update', status: :unprocessable_entity
        end
      end
    end
  end
end
