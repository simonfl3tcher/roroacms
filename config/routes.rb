Railsoverview::Application.routes.draw do

  resources :articles

  get 'register', to: 'users#new', as: 'register'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  # get 'profile', to: 'profile#index', as: 'profile'
  
  resources :pages 
  resources :users
  resources :sessions
  resources :profile
  resources :upload

  namespace :admin do
    get '', to: 'dashboard#index'
    get 'login', to: 'login#new', as: 'login'
    get 'trash', to: 'trash#index', as: 'trash'
    get 'logout', to: 'login#destroy', as: 'logout'
    get 'posts/categories', to: 'terms#index', as: 'post_categories'
    
    resources :login, :users, :administrators, :upload, :reports

    resources :revisions do
        member {get 'restore'}
      # collection do 
      #   # get 'restore'
      # end
    end

    resources :terms do
      collection do
        post 'bulk_update'
      end
    end

    resources :posts do
      collection do
        post 'bulk_update'
        post 'autosave_create'
        put 'autosave_update'
        post 'update_from_air'
      end
    end

    resources :pages do
      collection do
        post 'bulk_update'
      end
    end

    resources :trash do
      collection do
        get 'empty_posts'
        post 'deal_with_form'
      end
    end

    namespace :settings do
      resources :general do
        post :update_general
      end
      # resources :seo do
      #   # post :update_general
      # end
    end
  end 

  root to: 'pages#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'home#index', as: 'home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  match '/*slug', :to => 'pages#dynamic_page'
  match '*not_found', to: 'errors#error_404' #unless Rails.application.config.consider_all_requests_local
end
