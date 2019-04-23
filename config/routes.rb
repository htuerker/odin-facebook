Rails.application.routes.draw do
  root "posts#index"
  devise_for :users
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end
  get 'me', to: 'users#me'
  get 'me/friends', to: 'users#friends'
  resources :users, only: [:index, :show]
  resources :posts
  resources :friend_requests, only: [:create, :update, :destroy]
end
