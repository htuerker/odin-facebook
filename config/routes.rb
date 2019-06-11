# frozen_string_literal: true

Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end

  get 'user/:user_id/friends', to: 'friendships#index', as: 'user_friends'
  get 'comments_by_post/:post_id/:comments_page', to: 'comments#comments_by_post', as: 'comments_by_post'

  resources :users, only: %i[index show]
  resources :posts, only: %i[index show create destroy]
  resources :comments, only: %i[create destroy]
  resources :friend_requests, only: %i[index create destroy]
  resources :friendships, only: %i[index create destroy]
  resources :likes, only: %i[create destroy]
end
