Rails.application.routes.draw do
  root "posts#index"
  devise_for :users
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end
  get 'me', to: 'users#me'
  get 'me/friends', to: 'users#friends'

  # TO-DO refactor it with using routing scopes
  post 'friend_requests/accept/:id', to: 'friend_requests#accept', as: 'friend_request_accept'
  post 'friend_requests/decline/:id', to: 'friend_requests#decline', as: 'friend_request_decline'

  resources :users, only: [:index, :show]
  resources :posts
  resources :friend_requests, only: [:create, :update, :destroy]
end
