RemindersApi::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :accounts, except: [:index, :new, :edit]

      resources :event_lists, except: [:new, :edit] do
        resources :events, except: [:new, :edit]
      end

      resources :events, except: [:new, :edit, :create]

      resources :subscribers, only: [:index, :show, :create, :update, :destroy]
    end
  end

  match '/404', to: 'errors#not_found'
end
