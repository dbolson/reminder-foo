module Api
  module V1
    class EventsController < Api::ApiController
      respond_to :json, :xml

      def index
        @events = current_account.events.all
      end

      def show
        @event = current_account.events.find(params[:id])
      end

      def update
        @event = current_account.events.find(params[:id])

        if @event.update_attributes(params[:event])
          render 'update'
        else
          render 'update', status: :not_modified
        end
      end

      def destroy
        @event = current_account.events.find(params[:id])
        @event.destroy
      end
    end
  end
end
