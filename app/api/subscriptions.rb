module API
  class Subscriptions < BaseV1
    before do
      authenticate!
    end
    #
    # GET index
    desc 'Get all subscriptions', {
      http_codes: {
        200 => 'Subscriptions found',
        401 => 'Unauthorized access'
      }
    }

    get '/subscriptions' do
      subscriptions = current_account.subscriptions
      represent_collection(subscriptions)
    end

    # GET show
    desc 'Get ID of subscription', {
      http_codes: {
        200 => 'Subscription found',
        401 => 'Unauthorized access',
        404 => 'Invalid Subscription '
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the subscription'
    end

    get '/subscriptions/:id' do
      subscription = current_account.subscriptions.find(params[:id])
      represent(subscription)
    end

    # POST create
    desc 'Creates a subscription', {
      http_codes: {
        201 => 'Successfully created',
        401 => 'Unauthorized access',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :event_list_id, type: String, desc: 'ID of the event list'
      requires :subscriber_id, type: String, desc: 'ID of the subscriber'
    end

    post '/subscriptions' do
      parameters = ActionController::Parameters.new(params)
      subscription = ::Subscription.
        create_for_account(account: current_account,
                           subscription: parameters.permit(:event_list_id, :subscriber_id))
      represent(subscription)
    end

    # DELETE destroy
    desc 'Deletes a subscription', {
      http_codes: {
        204 => 'Successfully deleted',
        401 => 'Unauthorized access',
        404 => 'Invalid subscription'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the subscription'
    end

    delete '/subscriptions/:id' do
      subscription = current_account.subscriptions.find(params[:id])
      subscription.destroy
      no_content!
    end
  end
end
