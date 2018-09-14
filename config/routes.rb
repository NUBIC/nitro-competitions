# -*- coding: utf-8 -*-
NucatsAssist::Application.routes.draw do
  # omniauth and login/logout
  devise_for :external_users, skip: [ :sessions ], 
              controllers: { confirmations: 'external_user/confirmations', 
              passwords: 'external_user/passwords',
              registrations: 'external_user/registrations' } 
  devise_for :ldap_users, skip: [ :sessions ]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_scope :ldap_user do
    get 'sign-in' => 'sessions#new', as: :new_session
    post 'sign-in' => 'sessions#create', as: :create_session
    delete 'sign-out' => 'sessions#destroy', as: :destroy_session
  end

  # devise_scope :external_user do
  #   get 'sign_up' => 'external_user/registrations#new'

    # get 'passwords/new' => 'external_user/passwords#new', as: :new_password
    # get 'passwords/edit' => 'external_user/passwords#edit', as: :edit_password
    # patch 'passwords/update' => 'external_user/passwords#update', as: :update_password

  # end

  # resources
  resources :file_documents, only: :show
  resources :audits, only: :index do
    collection do
      get :activities
      get :login_data
      get :activity_data
      get :user_data
      get :applicant_data
      get :application_data
      get :key_personnel_data
      get :reviewer_data
      get :review_data
      get :sponsor
    end
    member do
      get :program_data
    end
  end

  resources :sponsors, except: [:delete] do
    member do
      get :contact
      post :opt_out_submission_notification
      post :opt_in_submission_notification
    end
    resources :roles, only: [:index, :show]
    resources :users, only: [] do
      resources :roles, only: [] do
        member do
          get :remove
          get :add
        end
      end
    end
  end

  resources :projects do
    resources :duplications, controller: 'projects/duplications', only: [:new]

    member do
      get :all_reviews
      get :membership_required
    end
    resources :submissions, only: [:index]
    resources :applicants, except: [:destroy] do
      resources :submissions, only: [:new, :create]
    end

    resources :approvers, only: [:index, :update]
    resources :reviewers, only: [:index, :edit, :update, :destroy] do
      collection do
        get :all_reviews
        get :complete_listing
        get :complete_listing_with_files
        get :index_with_files
      end
      member do
        get :save_review_item
        post :save_review_item
      end
    end
    resources :admins, only: :index do
      collection do
        get :reviews
        get :view_applicants
        get :view_activities
        get :view_submissions
        get :view_reviews
        get :view_logins
        get :view_sponsor_applicants
        get :reviewers
        get :submissions
        post :add_reviewers
        post :unassign_submission
        get :act_as_user
        post :act_as_user
        get :user_lookup
        post :user_lookup
      end
      member do
        get :remove_reviewer
        post :remove_reviewer
        post :assign_submission
      end
    end
  end

  resources :reviewers, only: [:edit, :update, :destroy] do
    collection do
      get :all
      get :all_with_files
    end
  end

  resources :submissions, except: [:new] do
    collection do
      get :all
    end
    member do
      get :reassign_applicant
      post :reassign_applicant
      put :update_key_personnel
      post :update_key_personnel
      get :edit_documents
      post :edit_documents
    end
    resources :reviews, only: [:index]
    resources :key_personnel, except: :new do
      collection do
        get :add_new
        post :add_new
        get :lookup
        post :lookup
      end
    end
  end

  namespace :competitions do
    get :open
  end

  namespace :api do
    resources :projects, only: :index
  end

  resources :applicants, only: [:edit, :update, :show]

  resources :public, only: [:welcome, :home]

  # other
  root to: 'public#welcome'
  get 'welcome' => 'public#welcome', as: :welcome
  get 'home' => 'public#home', as: :home
  get 'disallowed' => 'public#disallowed', as: :disallowed
  get '/public/:name' => redirect('/%{name}', status: 302)

  # match 'auth' => 'public#auth', as: :auth, via: [:get, :post]
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  match 'competitions/:program_name/:project_name' => 'projects#show', as: :show_competition, via: [:get]
  match 'competitions/:program_name' => 'projects#index', as: :competitions, via: [:get]
  match 'role/:id/add_user/:user_id' => 'roles#add_user', as: :add_user_role, via: [:get, :post]
  match 'role/:user_role_id/remove_user' => 'roles#remove_user', as: :remove_user_role, via: [:get, :post]

  match 'review/:id/update_item' => 'reviews#update_item', as: :update_review_item, via: [:get, :post]
  match 'username_lookup' => 'applicants#username_lookup', via: [:get, :post]

  match '/projects/:id/copy' => 'projects/duplications#new', as: :copy_project, via: [:get]

end
