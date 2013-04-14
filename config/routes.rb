RemindersApi::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :accounts, except: [:index, :new, :edit]
      resources :event_lists, except: [:new, :edit] do
        resources :events, except: [:new, :edit]
        resources :subscribers, except: [:new, :edit, :update],
          controller: 'event_lists/subscribers'
      end
      resources :events, except: [:new, :edit, :create]
      resources :subscribers, except: [:new, :edit]
    end
  end

  match '/404', to: 'errors#not_found'
end
