module Api
  module V1
    class EventListsController < Api::ApiController
      respond_to :json, :xml

      def index
        @event_lists = current_account.ordered_event_lists
        @status = 200
      end

      def show
        @event_list = current_account.event_lists.find(params[:id])
        @status = 200
      end

      def create
        @event_list = current_account.event_lists.new(params[:event_list])

        if @event_list.save
          @status = 201
          render 'create', status: @status
        else
          @status = 422
          render 'create', status: @status
        end
      end

      def update
        @event_list = current_account.event_lists.find(params[:id])

        if @event_list.update_attributes(params[:event_list])
          @status = 200
          render 'update'
        else
          @status = 304
          render 'update', status: @status
        end
      end

      def destroy
        @event_list = current_account.event_lists.find(params[:id])
        @event_list.destroy
        @status = 200
      end
    end
  end
end
