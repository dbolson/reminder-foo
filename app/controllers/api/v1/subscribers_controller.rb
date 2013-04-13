module Api
  module V1
    class SubscribersController < Api::ApiController
      respond_to :json, :xml

      def index
        @subscribers = current_account.subscribers.all
      end

      def show
        @subscriber = current_account.subscribers.find(params[:id])
      end

      def update
        @subscriber = current_account.subscribers.find(params[:id])

        if @subscriber.update_attributes(params[:subscriber])
          render 'update'
        else
          render 'update', status: :not_modified
        end
      end

      def destroy
        @subscriber = current_account.subscribers.find(params[:id])
        @subscriber.destroy
      end
    end
  end
end