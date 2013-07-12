module API
  class Reminders < BaseV1
    before do
      authenticate!
    end

    # GET index
    desc 'Get all reminders for the event', {
      http_codes: {
        200 => 'Reminders found',
        401 => 'Unauthorized access'
      }
    }

    namespace :events do
      segment '/:event_id' do
        get '/reminders' do
          event = current_account.events.find(params[:event_id])
          reminders = event.reminders
          represent_collection(reminders)
        end
      end
    end

    # GET show
    desc 'Get ID of reminder', {
      http_codes: {
        200 => 'Reminder found',
        401 => 'Unauthorized access',
        404 => 'Invalid reminder'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the reminder'
    end

    namespace :events do
      segment '/:event_id' do
        get '/reminders/:id' do
          event = current_account.events.find(params[:event_id])
          reminder = event.reminders.find(params[:id])
          represent(reminder)
        end
      end
    end

    # POST create
    desc 'Creates a reminder', {
      http_codes: {
        201 => 'Successfully created',
        401 => 'Unauthorized access',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :reminded_at, type: String, desc: 'Date reminder is sent out'
    end

    namespace :events do
      segment '/:event_id' do
        post '/reminders' do
          parameters = ActionController::Parameters.new(params)
          event = current_account.events.find(params[:event_id])
          reminder = event.reminders.new(parameters.permit(:reminded_at))
          reminder.save!
          represent(reminder)
        end
      end
    end

    # PUT update
    desc 'Updates a reminder', {
      http_codes: {
        200 => 'Successfully updated',
        401 => 'Unauthorized access',
        404 => 'Invalid reminder',
        422 => 'Invalid parameters'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the reminder'
      optional :reminded_at, type: String, desc: 'Date reminder is sent out'
    end

    namespace :events do
      segment '/:event_id' do
        put '/reminders/:id' do
          parameters = ActionController::Parameters.new(params)
          event = current_account.events.find(params[:event_id])
          reminder = event.reminders.find(params[:id])
          reminder.update_attributes!(parameters.permit(:reminded_at))
          represent(reminder)
        end
      end
    end

    # DELETE destroy
    desc 'Deletes a reminder', {
      http_codes: {
        204 => 'Successfully deleted',
        401 => 'Unauthorized access',
        404 => 'Invalid reminder'
      }
    }

    params do
      requires :id, type: String, desc: 'ID of the reminder'
    end

    namespace :events do
      segment '/:event_id' do
        delete '/reminders/:id' do
          event = current_account.events.find(params[:event_id])
          reminder = event.reminders.find(params[:id])
          reminder.destroy
          no_content!
        end
      end
    end
  end
end
