Rails.application.routes.draw do
  root "posts#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end
  get 'me', to: 'users#me'
  get 'me/friends', to: 'users#friends'

  # TO-DO refactor it with using routing scopes
  post 'friend_requests/accept/:id', to: 'friend_requests#accept', as: 'friend_request_accept'
  post 'friend_requests/decline/:id', to: 'friend_requests#decline', as: 'friend_request_decline'

  delete 'friendship/:user_id', to: 'friendships#destroy', as: 'friendship'
  resources :users, only: [:index, :show]
  resources :posts
  resources :comments, only: [:create, :destroy]
  resources :friend_requests, only: [:create, :update, :destroy]
  resources :likes, only: [:create, :destroy]
end
