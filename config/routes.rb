RemindersApi::Application.routes.draw do
  root to: 'pages#lists'

  match '/lists', to: 'pages#lists'
  match '/account', to: 'pages#account'
  match '/sign_in', to: 'pages#sign_in'

  #namespace :api, defaults: { format: :json } do
    #namespace :v1 do
      #match 'accounts', to: 'accounts#show', via: :get

      #resources :event_lists, except: [:new, :edit] do
        #get :subscribers, on: :member
        #get :subscriptions, on: :member

        #resources :events, except: [:new, :edit], controller: 'event_lists/events'
      #end

      #resources :events, except: [:new, :edit, :create] do
        #resources :reminders, except: [:new, :edit], controller: 'events/reminders'
      #end

      #resources :subscribers, except: [:new, :edit] do
        #get :event_lists, on: :member
        #get :subscriptions, on: :member
      #end

      #resources :subscriptions, only: [:create, :destroy]
    #end
  #end

  mount API::Root => '/api'
  get '/api/documentation', to: 'api_documentation#index'

  #match '/404', to: 'errors#not_found'
  #match '/500', to: 'errors#internal_server_error'
end
