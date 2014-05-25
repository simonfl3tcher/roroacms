Roroacms::Application.routes.draw do
  
  devise_for :admins, :path => "admin", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'reset', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'register' }, skip: :registrations

  devise_scope :admin do
    get "admin/login", :to => "devise/sessions#new"
    get "admin/logout", :to => "devise/sessions#destroy"
  end

  resources :pages,  only: [:index, :show, :dynamic_page, :contact_form]
  resources :comments

  post 'email', to: 'pages#contact_form'

  
  namespace :admin do
    get '', to: 'dashboard#index'
    get 'login', to: 'login#new', as: 'login'
    get 'trash', to: 'trash#index', as: 'trash'
    get 'logout', to: 'login#destroy', as: 'logout'
    get 'posts/categories', to: 'terms#categories', as: 'post_categories'
    get 'posts/tags', to: 'terms#tags', as: 'post_tags'
    
    resources :login, :users, :administrators, :themes

    resources :menus do 

      collection do 
        post 'save_menu'
        post 'ajax_dropbox'
      end

    end 
    resources :editor do

      collection do 
        put 'update_from_air'
      end

    end

    # resources :media do

    #   collection do
    #     post 'delete_via_ajax'
    #     post 'bulk_update'
    #     post 'get_via_ajax'
    #     post 'get_folder_list'
    #     post 'multipleupload'
    #     post 'rename_media'
    #   end

    # end

    resources :filebrowser do
        member {post 'upload'}
        collection do
          post 'upload'
          post 'multipleupload'
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
        get 'empty_posts'
        post 'deal_with_form'
      end
    end

    namespace :settings do
      resources :general do
        post :update_general
        collection do 
          post 'create_user_group'
        end
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
