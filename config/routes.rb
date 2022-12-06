Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [] do
    member do
      post :follow
      post :unfollow
      get :follower_records
    end
  end
  
  get 'users/:user_id/alarms' => 'alarms#index'

  resources :alarms, only: [:update] do
    collection do
      post :clock_in
      post :clock_out
      get :sleep_record
    end
  end
end
