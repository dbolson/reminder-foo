module Api
  module V1
    class EventLists::SubscribersController < Api::ApiController
      before_filter :find_event_list

      respond_to :json, :xml

      def index
        @subscribers = @event_list.subscribers.all
        render 'api/v1/subscribers/index'
      end

      def show
        @subscriber = @event_list.subscribers.find(params[:id])
        render 'api/v1/subscribers/show'
      end

      def create
        @subscriber = current_account.subscribers.find(params[:id])
        @subscription = @event_list.subscriptions.build
        @subscription.subscriber = @subscriber

        if @subscription.save
          render 'api/v1/subscribers/create'
        else
          render 'api/v1/subscribers/create', status: :unprocessable_entity
        end
      end

      def destroy
        @subscriber = @event_list.subscribers.find(params[:id])
        @subscription = @event_list.subscriptions.find_by_subscriber_id(@subscriber)
        @subscription.destroy
        render 'api/v1/subscribers/destroy'
      end

      private

      def find_event_list
        @event_list = current_account.event_lists.find(params[:event_list_id])
      end
    end
  end
end
