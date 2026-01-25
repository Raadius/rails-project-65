# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/logout', to: 'auth#destroy', as: :logout

    root 'bulletins#index'

    resources :bulletins, only: %i[index show new create edit update] do
    end

    namespace :admin do
      root 'home#index'
      resources :categories
      resources :bulletins
    end
  end
end
