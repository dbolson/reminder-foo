RemindersApi::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :accounts, only: [:show, :update, :create, :destroy]
      resources :event_lists, only: [:index, :show, :update, :create, :destroy]
    end
  end

  match '/404', to: 'errors#not_found'
end
