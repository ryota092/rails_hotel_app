Rails.application.routes.draw do
  resources :users, only: [ :new, :create, :edit, :update, :show ] do
    member do
      get :profile_edit
      patch :profile_update
      get :account_edit
      patch :account_update
    end
  end

  resources :sessions, only: [ :new, :create, :destroy ]
  resources :rooms do
    collection do
      get :search
    end
  end

  resources :reservations
  delete "/logout", to: "sessions#destroy", as: :logout
  root "pages#home"
  get "/top", to: "rooms#index", as: :top

  resources :reservations do
    collection do
      post :confirm
    end
  end
end
