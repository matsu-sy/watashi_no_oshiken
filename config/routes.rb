Rails.application.routes.draw do
  get "hometowns/create"
  get "hometowns/update"
  get "hometowns/destroy"
  devise_for :users

  authenticated :user do
    root "posts#index", as: :authenticated_root
  end

    resource :mypage, only: %i[show edit update] do
      delete :avatar, to: "mypages#destroy_avatar"
    end
    resources :hometowns, only: %i[create update destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#top"

  resources :posts, only: %i[index new create show edit update destroy] do
    resources :reactions, only: %i[create] do
      collection do
        delete :destroy
      end
    end
  end
end
