module Api
  module V1
    class Events::RemindersController < Api::ApiController
      before_filter :find_event

      respond_to :json, :xml

      def index
        @reminders = @event.reminders.all
        render 'index'
      end

      def show
        @reminder = @event.reminders.find(params[:id])
        render 'show'
      end

      def create
        @reminder = @event.reminders.build(reminder_params)

        if @reminder.save
          render 'create', status: :created, location: api_v1_event_reminder_url(@event, @reminder)
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def update
        @reminder = @event.reminders.find(params[:id])

        if @reminder.update_attributes(reminder_params)
          render 'update'
        else
          render 'update', status: :unprocessable_entity
        end
      end

      def destroy
        @reminder = @event.reminders.find(params[:id])
        @reminder.destroy
        render nothing: true, status: :no_content
      end

      private

      def find_event
        @event = current_account.events.find(params[:event_id])
      end

      def reminder_params
        params.require(:reminder).permit(:reminded_at)
      end
    end
  end
end
