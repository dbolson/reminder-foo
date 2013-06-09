module Api
  module V1
    class EventLists::EventsController < Api::ApiController
      respond_to :json, :xml

      def index
        @events = current_account.events.all
        render 'api/v1/events/index'
      end

      def show
        @event = current_account.events.find(params[:id])
        render 'api/v1/events/show'
      end

      def create
        @event_list = EventList.find(params[:event_list_id])
        @event = Services::EventCreating.create(create_params(@event_list))

        if @event.persisted?
          render 'create', status: :created, location: api_v1_event_url(@event)
        else
          render 'create', status: :unprocessable_entity
        end
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
        render nothing: true, status: :no_content
      end

      private

      def create_params(event_list)
        params[:event] = {} if params[:event].blank?
        { account: current_account, event_list: event_list }.merge(params[:event])
      end

      def event_params
        params.require(:event).permit(:name, :description, :due_at)
      end
    end
  end
end
