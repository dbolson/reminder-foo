module Api
  module V1
    class EventListsController < Api::ApiController
      respond_to :json, :xml

      def subscribers
        @event_list = current_account.event_lists.find(params[:id])
      end

      def subscriptions
        @event_list = current_account.event_lists.find(params[:id])
      end

      def index
        @event_lists = current_account.ordered_event_lists
      end

      def show
        @event_list = current_account.event_lists.find(params[:id])
      end

      def create
        @event_list = current_account.event_lists.new(event_list_params)

        if @event_list.save
          render 'create', status: :created
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def update
        @event_list = current_account.event_lists.find(params[:id])

        if @event_list.update_attributes(event_list_params)
          render 'update'
        else
          render 'update', status: :unprocessable_entity
        end
      end

      def destroy
        @event_list = current_account.event_lists.find(params[:id])
        @event_list.destroy
      end

      private

      def event_list_params
        params.require(:event_list).permit(:name)
      end
    end
  end
end
