Rails.application.routes.draw do
  devise_for :users
  as :user do
    get 'me/edit', to: 'devise/registrations#edit'
  end
  get 'me', to: 'users#me'
  resources :users, only: [:index, :show]
end
