module Api
  module V1
    class AccountsController < Api::ApiController
      respond_to :json, :xml

      def show
        @account = Account.find(params[:id])
      end

      def create
        @account = Services::AccountCreating.create(params[:account])

        if @account.persisted?
          render 'create'
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def update
        @account = Account.find(params[:id])

        if @account.update_attributes(params[:account])
          render 'update'
        else
          render 'update', status: :not_modified
        end
      end

      def destroy
        @account = Account.find(params[:id])
        @account.destroy
      end
    end
  end
end
