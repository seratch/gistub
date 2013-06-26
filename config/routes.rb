Gistub::Application.routes.draw do

  root :to => 'root#index'

  resources :gists do

    post :fork

    member do
      get 'history/:gist_history_id' => 'gists#show_history', :as => :show_history
      get 'raw_file/:gist_file_id' => 'gists#show_raw_file', :as => :show_raw_file, :format => :text
    end

    collection do
      get :page
      get :find_my_recent_gists
      get :mine
      get :mine_page
      get :user_page
      get :user_fav_page
      get :add_gist_files_input
      get :search
    end

    resources :comments, :only => [:create, :destroy]
    resources :favorites, :only => [:create, :destroy]

  end

  resources :users, :only => [:edit, :update, :destroy, :show]

  get '/signin' => 'sessions#start', :as => :signin
  get '/auth/:provider/callback' => 'sessions#create'
  post '/auth/:provider/callback' => 'sessions#create'
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

end
