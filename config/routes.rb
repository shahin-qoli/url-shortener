Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] 
      resources :urls, only: [] do
        collection do
          post 'encode'
          post 'decode'
        end
      end
    end
    namespace :auth do
      post '/login', to: 'authentication#login' 
    end     
  end
end
