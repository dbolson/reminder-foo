module Api
  module V1
    class EventLists::EventsController < Api::ApiController
      respond_to :json, :xml

      def index
        @events = current_account.events.all
        render 'events/index'
      end

      def show
        @event = current_account.events.find(params[:id])
        render 'events/show'
      end

      def create
        @event = Services::EventCreate.create(
          params.merge(account: current_account, event_list: @event_list)
        )

        if @event.save
          render 'create'
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def update
        @event = current_account.events.find(params[:id])

        if @event.update_attributes(params[:event])
          render 'events/update'
        else
          render 'events/update', status: :not_modified
        end
      end

      def destroy
        @event = current_account.events.find(params[:id])
        @event.destroy
        render 'events/destroy'
      end
    end
  end
end
