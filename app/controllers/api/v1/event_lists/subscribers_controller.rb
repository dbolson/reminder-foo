module Api
  module V1
    class EventLists::SubscribersController < Api::ApiController
      before_filter :find_event_list

      respond_to :json, :xml

      def index
        @subscribers = @event_list.subscribers.all
        render 'subscribers/index'
      end

      def show
        @subscriber = @event_list.subscribers.find(params[:id])
        render 'subscribers/show'
      end

      def create
        @subscriber = @event_list.subscribers.build(params[:subscriber])

        if @subscriber.save
          render 'create'
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def update
        @subscriber = @event_list.subscribers.find(params[:id])

        if @subscriber.update_attributes(params[:subscriber])
          render 'subscribers/update'
        else
          render 'subscribers/update', status: :not_modified
        end
      end

      def destroy
        @subscriber = @event_list.subscribers.find(params[:id])
        @subscriber.destroy
        render 'subscribers/destroy'
      end

      private

      def find_event_list
        @event_list = current_account.event_lists.find(params[:event_list_id])
      end
    end
  end
end

#e = EventList.first
#s = Subscriber.first
#e.subscribers << s
#Account.first.subscribers.create(phone_number: '5555555555')

=begin
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/event_lists/1/subscribers?access_token=ee8fb0303b4066b297266c1f06a24945
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/event_lists/1/subscribers/1?access_token=ee8fb0303b4066b297266c1f06a24945
=end
