module Api
  module V1
    class SubscriptionsController < Api::ApiController
      respond_to :json, :xml

      def create
        @subscription = Subscription.create_for_account(account: current_account,
                                                        subscription: params[:subscription])

        if @subscription.persisted?
          render 'create', status: :created, location: api_v1_subscription_url(@subscription)
        else
          render 'create', status: :unprocessable_entity
        end
      end

      def destroy
        @subscription = current_account.subscriptions.find(params[:id])
        @subscription.destroy
      end
    end
  end
end
