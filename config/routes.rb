# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root to: redirect('/discounts')

  scope module: 'dashboard' do
    resources :discounts, only: %i[index new create] do
      namespace :code do
        resources :batches, only: %i[new create]
        resources :duplicates, only: :create
      end
    end
  end

  mount Sidekiq::Web => '/sidekiq' # Sidekiq portal
end
