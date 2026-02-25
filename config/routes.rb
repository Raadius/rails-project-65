# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get  'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    get  'auth/failure', to: 'auth#failure', as: :auth_failure
    delete 'auth/logout', to: 'auth#destroy', as: :logout

    root 'bulletins#index'

    resource 'profile', only: %i[show]

    resources :bulletins, only: %i[index show new create edit update] do
      member do
        patch :to_moderate
        patch :archive
        patch :restore_from_archive
      end
    end

    namespace :admin do
      root 'home#index'
      resources :categories

      resources :bulletins, only: %i[index show destroy] do
        member do
          patch :publish
          patch :reject
          patch :archive
        end
      end
    end
  end
end
