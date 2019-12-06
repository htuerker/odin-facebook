# frozen_string_literal: true

Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end

  resources :users, only: %i[index show] do
    resources :friendships, only: :index
  end
  resources :posts, only: %i[index show create destroy] do
    resources :comments, only: :index
  end
  resources :comments, only: %i[create destroy]
  resources :friend_requests, only: %i[index create destroy]
  resources :friendships, only: %i[index create destroy]
  resources :likes, only: %i[create destroy]
  resources :notifications, only: %i[index]
end
