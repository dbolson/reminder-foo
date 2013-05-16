RemindersApi::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      match 'accounts', to: 'accounts#show', via: :get
      match 'accounts', to: 'accounts#update', via: :put

      resources :event_lists, except: [:new, :edit] do
        resources :events, except: [:new, :edit],
          controller: 'event_lists/events'

        resources :subscribers, except: [:new, :edit, :update],
          controller: 'event_lists/subscribers'
      end

      resources :events, except: [:new, :edit, :create] do
        resources :reminders, except: [:new, :edit],
          controller: 'events/reminders'
      end

      resources :subscribers, except: [:new, :edit]
    end
  end

  match '/404', to: 'errors#not_found'
end
