Rails.application.routes.draw do
  devise_for :users,
    defaults: { format: :json },
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

    devise_scope :user do
      put 'change_password', to: 'users/passwords#change_password'
      delete 'delete_account', to: 'users/registrations#destroy_account'
      post "users/password/send_otp",   to: "users/passwords#send_otp"
      post "users/password/verify_otp", to: "users/passwords#verify_otp"
      post "users/password/reset",      to: "users/passwords#reset_password"
      post "users/create_admin_user",   to: "users/registrations#createAdminUser"
     
    end

    root "home#index"

    namespace :api do
      namespace :v1 do

        # resources :franchise do
        #   collection do 
        #     get 'filter_franchices', to: 'franchise#filter_franchises'
        #   end
        #   resources :staffs, only: [:create, :update, :destroy] do
        #     member do
        #       patch :update_permissions
        #       post  :create_staff
        #       post  :create_staff
        #     end
        #   end
        # end

        resources :franchise do
          collection do 
            get 'filter_franchices', to: 'franchise#filter_franchises'
          end
          member do
            post :upload_logo
            post :upload_banner
          end
          resources :staffs, only: [:create, :update, :destroy] do
            member do
              patch :update_permissions
              # post  :create_staff   
            end
            collection do
              post :create_staff
            end
          end
          resources :videos, only: [:create, :index, :destroy]
        end
        resources :franchise_reviews, only: [:index, :create, :update ,:destroy]
        resources :templates


        resources :conversations do
          resources :messages, only: [:create, :destroy] do
            collection do
              get :inbox
              get :sent
              post :contact
            end
          end
        end



        resources :notifications do
          member do
            patch :toggle  # toggle enable/disable
          end
        end

        # resources :franchise_details do
        #   member do
        #     delete :delete_image
        #   end
        # end

        # resources :franchise_details do
        #   member do
        #     patch :update_images
        #   end
        # end

        resources :user_settings do 
          collection do 
            post :change_role
            post :create_admin_role
            put :update_admin_role
            get :fetch_roles
          end
        end

        resources :franchise_details do
          member do
            patch :update_images
            delete "delete_image/:image_id", action: :delete_image
          end
        end
        resources :news
        resources :favorite, only: [:index, :create, :destroy]
        resource :profiles
        post "/presigned_url", to: "user_settings#create_presigned_url"
        resources :documents, only: [:index, :create, :destroy] do
          collection do
            post :create_presigned_url
          end
        end
      end

      
    end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  

end
