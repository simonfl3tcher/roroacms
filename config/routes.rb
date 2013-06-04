Railsoverview::Application.routes.draw do

  # mount RedactorRails::Engine => '/redactor_rails'

  resources :articles
  
  resources :pages 
  resources :sessions
  resources :comments

  namespace :admin do
    get '', to: 'dashboard#index'
    get 'login', to: 'login#new', as: 'login'
    get 'trash', to: 'trash#index', as: 'trash'
    get 'logout', to: 'login#destroy', as: 'logout'
    get 'posts/categories', to: 'terms#categories', as: 'post_categories'
    get 'posts/tags', to: 'terms#tags', as: 'post_tags'
    
    resources :login, :users, :administrators

    resources :media do

      collection do
        get 'delete'
        post 'bulk_update'
      end

    end

    resources :banners do 
      collection do
          get 'categories'
        end
    end

    resources :filebrowser do
        member {post 'upload'}
        collection do
          post 'upload'
          get 'delete'
        end
    end

    resources :revisions do
        member {get 'restore'}
    end

    resources :terms do
      collection do
        post 'bulk_update'
      end
    end

    resources :comments do
      member {get 'mark_as_spam'}
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
