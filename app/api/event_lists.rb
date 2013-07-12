module API
  class EventLists < BaseV1
    before do
      authenticate!
    end

    # GET index
    desc 'Get all event lists', {
      http_codes: {
        200 => 'Event lists found',
        401 => 'Unauthorized access'
      }
    }

    get '/event_lists' do
      event_lists = current_account.ordered_event_lists
      represent_collection(event_lists)
    end

    # GET show
    desc 'Get ID of event list', {
      http_codes: {
        200 => 'Event list found',
        401 => 'Unauthorized access',
        404 => 'Invalid event list'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the event list'
    end

    get '/event_lists/:id' do
      event_list = current_account.event_lists.find(params[:id])
      represent(event_list)
    end

    # POST create
    desc 'Creates an event list', {
      http_codes: {
        201 => 'Successfully created',
        401 => 'Unauthorized access',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :name, type: String, desc: 'Name of the event list'
    end

    post '/event_lists' do
      parameters = ActionController::Parameters.new(params)
      event_list = current_account.event_lists.new(parameters.permit(:name))
      event_list.save!
      represent(event_list)
    end

    # PUT update
    desc 'Updates an event list', {
      http_codes: {
        200 => 'Successfully updated',
        401 => 'Unauthorized access',
        404 => 'Invalid event list',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the event list'
      optional :name, type: String, desc: 'Name of the event list'
    end

    put '/event_lists/:id' do
      parameters = ActionController::Parameters.new(params)
      event_list = current_account.event_lists.find(params[:id])
      event_list.update_attributes!(parameters.permit(:name))
      represent(event_list)
    end

    # DELETE destroy
    desc 'Deletes an event list', {
      http_codes: {
        204 => 'Successfully deleted',
        401 => 'Unauthorized access',
        404 => 'Invalid event list'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the event list'
    end

    delete '/event_lists/:id' do
      event_list = current_account.event_lists.find(params[:id])
      event_list.destroy
      no_content!
    end

    # GET subscribers
    desc 'Get all subscribers for the event list', {
      http_codes: {
        200 => 'Subscribers found',
        401 => 'Unauthorized access'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the event list'
    end

    get '/event_lists/:id/subscribers' do
      event_list = current_account.event_lists.find(params[:id])
      subscribers = event_list.subscribers
      represent_collection(subscribers)
    end
  end
end
