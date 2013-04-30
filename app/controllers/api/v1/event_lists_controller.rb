module Api
  module V1
    class EventListsController < Api::ApiController
      respond_to :json, :xml

      def index
        @event_lists = current_account.ordered_event_lists
      end

      def show
        @event_list = current_account.event_lists.find(params[:id])
      end

      def create
        @event_list = current_account.event_lists.new(params[:event_list])

        if @event_list.save
          render 'create', status: :created
        else
          render 'create', status: :unprocessible_entity
        end
      end

      def update
        @event_list = current_account.event_lists.find(params[:id])

        if @event_list.update_attributes(params[:event_list])
          render 'update'
        else
          render 'update', status: :not_modified
        end
      end

      def destroy
        @event_list = current_account.event_lists.find(params[:id])
        @event_list.destroy
      end
    end
  end
end
