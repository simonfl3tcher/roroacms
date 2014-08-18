Roroacms::Engine.routes.draw do

  devise_for :admins, class_name: "Roroacms::Admin", :path => "admin", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'reset', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'register' }, skip: :registrations, module: :devise
  
  devise_scope :admin do
    get "admin/login", :to => "devise/sessions#new"
    get "admin/logout", :to => "devise/sessions#new"
  end
  
  resources :pages
  resources :comments

  resources :setup do 
    member { get 'tour_complete' }
    collection do 
      get 'administrator'
      post 'create_user'
      post 'tour_complete'
    end
  end
  
  namespace :admin do
    get '', to: 'dashboard#index'
    get 'trash', to: 'trash#index', as: 'trash'
    get 'article/categories', to: 'terms#categories', as: 'article_categories'
    get 'article/tags', to: 'terms#tags', as: 'article_tags'
    
    resources :users, :themes


    resources :administrators, :except => [:show]

    resources :comments do
      member {get 'mark_as_spam'}
      collection do
        post 'bulk_update'
      end
    end

    resources :menus do 

      collection do 
        post 'save_menu'
        post 'ajax_dropbox'
      end

    end 

    resources :revisions, :only=> [:edit, :restore] do
        member {get 'restore'}
    end

    resources :terms do
      collection do
        post 'bulk_update'
      end
    end


    resources :articles do
      collection do
        post 'bulk_update'
        post 'autosave_create'
        post 'create_additional_data'
        post 'autosave'
        put 'autosave_update'
      end
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
  match '/*slug', :to => 'pages#dynamic_page', via: [:get], :constraints => lambda{|req| req.path !~ /\.(png|jpg|js|css)$/ }
	
end
