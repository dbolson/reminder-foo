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

        if @event.update_attributes(event_params)
          render 'update'
        else
          render 'update', status: :unprocessable_entity
        end
      end

      def destroy
        @event = current_account.events.find(params[:id])
        @event.destroy
      end

      private

      def event_params
        params.require(:event).permit(:name, :description, :due_at)
      end
    end
  end
end
