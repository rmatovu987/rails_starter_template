Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :dashboard, only: [ :index ] do
    collection do
      get :global_search
    end
  end
  namespace :system do
    resources :businesses
    resources :permission_nodes
    resources :permissions
    resources :audit_trails, only: [ :index ]
  end
  namespace :settings do
    resources :branches do
      member do
        put :activate
        put :close
      end
    end
    resources :roles do
      collection do
        put "update_permission/:id", to: "roles#update_permission", as: "update_permission"
      end
    end
  end
  resources :users do
    member do
      get :add_role
      get :add_branch
      post :assign_role
      post :attach_branch
      post :revoke_role
      post :detach_branch
      get :generate_user_token
      put :upload_photo
      get :edit_photo
      put :clear_photo
    end
    collection do
      get :my_profile
      get :change_password
      patch :update_password
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"
end
