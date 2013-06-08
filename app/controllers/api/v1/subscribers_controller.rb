module Api
  module V1
    class SubscribersController < Api::ApiController
      respond_to :json, :xml

      def event_lists
        @subscriber = current_account.subscribers.find(params[:id])
      end

      def subscriptions
        @subscriber = current_account.subscribers.find(params[:id])
      end

      def index
        @subscribers = current_account.subscribers.all
      end

      def show
        @subscriber = current_account.subscribers.find(params[:id])
      end

      def create
        @subscriber = current_account.subscribers.build(subscriber_params)

        if @subscriber.save
          render 'create', status: :created
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def update
        @subscriber = current_account.subscribers.find(params[:id])

        if @subscriber.update_attributes(subscriber_params)
          render 'update'
        else
          render 'update', status: :unprocessable_entity
        end
      end

      def destroy
        @subscriber = current_account.subscribers.find(params[:id])
        @subscriber.destroy
      end

      private

      def subscriber_params
        params.require(:subscriber).permit(:phone_number)
      end
    end
  end
end
