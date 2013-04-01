RemindersApi::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :event_lists, only: [
        :index, :show, :update, :create, :destroy
      ]
    end
  end

  match '/404', to: 'errors#not_found'

  mount ApiDoc::Engine => '/api_docs'
end
