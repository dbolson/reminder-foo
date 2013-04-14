module Api
  module V1
    class Events::RemindersController < Api::ApiController
      before_filter :find_event

      respond_to :json, :xml

      def index
        @reminders = @event_list.reminders.all
        render 'index'
      end

      def show
        @reminder = @event_list.reminders.find(params[:id])
        render 'show'
      end

      def create
        @reminder = @event.reminders.build(params[:reminder])

        if @reminder.save
          render 'create'
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def destroy
        @reminder = @event_list.reminders.find(params[:id])
        @reminder.destroy
        render 'destroy'
      end

      private

      def find_event
        @event = current_account.event.find(params[:event_id])
      end
    end
  end
end
