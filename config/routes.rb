Roroacms::Application.routes.draw do
  
  devise_for :admins, :path => "admin", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'reset', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'register' }, skip: :registrations

  devise_scope :admin do
    get "admin/login", :to => "devise/sessions#new"
    get "admin/logout", :to => "devise/sessions#destroy"
  end

  resources :pages,  only: [:index, :show, :dynamic_page]
  resources :comments
  
  namespace :admin do
    get '', to: 'dashboard#index'
    get 'trash', to: 'trash#index', as: 'trash'
    get 'article/categories', to: 'terms#categories', as: 'article_categories'
    get 'article/tags', to: 'terms#tags', as: 'article_tags'
    
    resources :login, :users, :themes

    resources :administrators, :except => [:show]

    resources :menus do 

      collection do 
        post 'save_menu'
        post 'ajax_dropbox'
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

    resources :articles, :except => [:show] do
      collection do
        post 'bulk_update'
        post 'autosave_create'
        post 'create_additional_data'
        put 'autosave_update'
      end
      member{ post 'update_from_air' }
    end

    resources :pages do
      collection do
        post 'bulk_update'
        post 'infinate_scroll'
      end
    end

    resources :trash do
      collection do
        get 'empty_articles'
        post 'deal_with_form'
      end
    end

    resources :settings do
      post :update_general
      collection do 
        post 'create_user_group'
      end
    end

  end 

  root to: 'pages#index'
  match '/*slug', :to => 'pages#dynamic_page'
end
