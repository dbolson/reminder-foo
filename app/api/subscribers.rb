module API
  class Subscribers < BaseV1
    before do
      authenticate!
    end

    # GET index
    desc 'Get all subscribers', {
      http_codes: {
        200 => 'Subscribers found',
        401 => 'Unauthorized access'
      }
    }

    get '/subscribers' do
      subscribers = current_account.subscribers
      represent_collection(subscribers)
    end

    # GET show
    desc 'Get ID of subscriber', {
      http_codes: {
        200 => 'Subscriber found',
        401 => 'Unauthorized access',
        404 => 'Invalid subscriber'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the subscriber'
    end

    get '/subscribers/:id' do
      subscriber = current_account.subscribers.find(params[:id])
      represent(subscriber)
    end

    # POST create
    desc 'Creates a subscriber', {
      http_codes: {
        201 => 'Successfully created',
        401 => 'Unauthorized access',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :phone_number, type: String, desc: 'Phone number of the subscriber'
    end

    post '/subscribers' do
      parameters = ActionController::Parameters.new(params)
      subscriber = current_account.subscribers.new(parameters.permit(:phone_number))
      subscriber.save!
      represent(subscriber)
    end

    # PUT update
    desc 'Updates a subscriber', {
      http_codes: {
        200 => 'Successfully updated',
        401 => 'Unauthorized access',
        404 => 'Invalid subscriber',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the subscriber'
      optional :phone_number, type: String, desc: 'Phone number of the subscriber'
    end

    put '/subscribers/:id' do
      parameters = ActionController::Parameters.new(params)
      subscribers = current_account.subscribers.find(params[:id])
      subscribers.update_attributes!(parameters.permit(:phone_number))
      represent(subscribers)
    end

    # DELETE destroy
    desc 'Deletes a subscriber', {
      http_codes: {
        204 => 'Successfully deleted',
        401 => 'Unauthorized access',
        404 => 'Invalid subscriber'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the subscriber'
    end

    delete '/subscribers/:id' do
      subscriber = current_account.subscribers.find(params[:id])
      subscriber.destroy
      no_content!
    end

    # GET subscribers
    desc 'Get all event lists for the subscriber', {
      http_codes: {
        200 => 'Event lists found',
        401 => 'Unauthorized access'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the subscriber'
    end

    get '/subscribers/:id/event_lists' do
      subscriber = current_account.subscribers.find(params[:id])
      event_lists = subscriber.event_lists
      represent_collection(event_lists)
    end
  end
end
