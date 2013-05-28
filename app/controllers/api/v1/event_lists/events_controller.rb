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
        create_params = params[:event].merge(account: current_account, event_list: @event_list)
        @event = Services::EventCreating.create(create_params)

        if @event.persisted?
          render 'create', status: :created
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def destroy
        @event = current_account.events.find(params[:id])
        @event.destroy
        render 'api/v1/events/destroy'
      end
    end
  end
end
