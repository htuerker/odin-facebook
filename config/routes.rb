Rails.application.routes.draw do
  root "posts#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end
  get 'me', to: 'users#me'
  get 'user/friends/:id', to: 'users#friends', as: "user_friends"

  # TO-DO refactor it with using routing scopes
  post 'friend_requests/accept/:id', to: 'friend_requests#accept', as: 'friend_request_accept'
  post 'friend_requests/decline/:id', to: 'friend_requests#decline', as: 'friend_request_decline'

  delete 'friendship/:user_id', to: 'friendships#destroy', as: 'friendship'
  get "comments_by_post/:post_id/:comments_page", to: "comments#comments_by_post", as: "comments_by_post"
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :create, :destroy]
  resources :comments, only: [:create, :destroy]
  resources :friend_requests, only: [:index, :create, :update, :destroy]
  resources :likes, only: [:create, :destroy]
end
