Railsoverview::Application.routes.draw do

  resources :articles
  
  resources :pages,  only: [:index, :show, :dynamic_page]
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
      resources :menu do 
        collection do 

          post 'sort'

        end
      end
    end
  end 

  root to: 'pages#index'
  match '/*slug', :to => 'pages#dynamic_page'
end
