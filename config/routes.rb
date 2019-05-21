Rails.application.routes.draw do
  root "posts#index"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end

  get 'user/:user_id/friends', to: 'friendships#index', as: "user_friends"
  get "comments_by_post/:post_id/:comments_page", to: "comments#comments_by_post", as: "comments_by_post"

  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :create, :destroy]
  resources :comments, only: [:create, :destroy]
  resources :friend_requests, only: [:index, :create, :update, :destroy]
  resources :friendships, only: [:index, :create, :destroy]
  resources :likes, only: [:create, :destroy]
end
