Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :v1, defaults: { format: :json } do
    resources :users, only: [] do
      member do
        post :follow
        post :unfollow
        get :followee_records
      end
    end

    get 'users/alarms' => 'alarms#index'

    resources :alarms, only: [:update] do
      collection do
        post :clock_in
        post :clock_out
      end
    end
  end
end
