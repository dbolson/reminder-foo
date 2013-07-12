module API
  class Events < BaseV1
    before do
      authenticate!
    end

    # GET index
    desc 'Get all events', {
      http_codes: {
        200 => 'Events found',
        401 => 'Unauthorized access'
      }
    }

    get '/events' do
      events = current_account.events
      represent_collection(events)
    end

    # GET index
    desc 'Get all events for the event list', {
      http_codes: {
        200 => 'Events found',
        401 => 'Unauthorized access'
      }
    }

    namespace :event_lists do
      segment '/:event_list_id' do
        get '/events' do
          event_list = current_account.event_lists.find(params[:event_list_id])
          events = event_list.events
          represent_collection(events)
        end
      end
    end

    # GET show
    desc 'Get ID of event', {
      http_codes: {
        200 => 'Event found',
        401 => 'Unauthorized access',
        404 => 'Invalid event'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the event'
    end

    namespace :event_lists do
      segment '/:event_list_id' do
        get '/events/:id' do
          event_list = current_account.event_lists.find(params[:event_list_id])
          event = event_list.events.find(params[:id])
          represent(event)
        end
      end
    end

    # POST create
    desc 'Creates an event', {
      http_codes: {
        201 => 'Successfully created',
        401 => 'Unauthorized access',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :name, type: String, desc: 'Name of the event'
      requires :description, type: String, desc: 'Description of the event'
      requires :due_at, type: String, desc: 'Due date of the event'
    end

    namespace :event_lists do
      segment '/:event_list_id' do
        post '/events' do
          parameters = ActionController::Parameters.new(params)
          event_list = current_account.event_lists.find(parameters[:event_list_id])
          event = event_list.events.new(parameters.permit(:name, :description, :due_at))
          event.account = current_account
          event.save!
          represent(event)
        end
      end
    end

    # PUT update
    desc 'Updates an event', {
      http_codes: {
        200 => 'Successfully updated',
        401 => 'Unauthorized access',
        404 => 'Invalid event',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the event'
      optional :name, type: String, desc: 'Name of the event'
      optional :description, type: String, desc: 'Description of the event'
      optional :due_at, type: String, desc: 'Due date of the event'
    end

    namespace :event_lists do
      segment '/:event_list_id' do
        put '/events/:id' do
          parameters = ActionController::Parameters.new(params)
          event_list = current_account.event_lists.find(params[:event_list_id])
          event = event_list.events.find(parameters[:id])
          event.update_attributes!(parameters.permit(:name, :description, :due_at))
          represent(event)
        end
      end
    end

    # DELETE destroy
    desc 'Deletes an event', {
      http_codes: {
        204 => 'Successfully deleted',
        401 => 'Unauthorized access',
        404 => 'Invalid event'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the event'
    end

    namespace :event_lists do
      segment '/:event_list_id' do
        delete '/events/:id' do
          event_list = current_account.event_lists.find(params[:event_list_id])
          event = event_list.events.find(params[:id])
          event_list.destroy
          no_content!
        end
      end
    end
  end
end
