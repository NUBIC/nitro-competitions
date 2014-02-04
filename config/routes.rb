# -*- coding: utf-8 -*-
NucatsAssist::Application.routes.draw do
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

  resources :sponsors, only: [:index, :show, :edit, :update] do
    member do
      get :contact
    end
    resources :roles, only: [:index, :show] do
      resources :users, only: [] do
        resources :rest, only: [] do
          member do
            get :remove
            get :add
          end
        end
      end
    end
  end

  resources :projects do
    member do
      get :all_reviews
    end
    resources :applicants do
      resources :submissions, only: [:new, :create]
    end

    resources :submissions, only: :index
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
      end
      member do
        get :remove_reviewer
        post :remove_reviewer
        post :assign_submission
      end
    end
  end

  resources :submissions, except: :index do
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

  resources :applicants, except: [:destroy]
  root to: 'public#welcome'
  match 'welcome' => 'public#welcome', :as => :welcome
  match 'competitions/:program_name/:project_name' => 'projects#show', :as => :show_competition
  match 'competitions/:program_name' => 'projects#index', :as => :competitions
  match 'role/:id/add_user/:user_id' => 'roles#add_user', :as => :add_user_role
  match 'role/:user_role_id/remove_user' => 'roles#remove_user', :as => :remove_user_role
  match 'projects' => 'projects#index', :as => :login_target
  match 'review/:id/update_item' => 'reviews#update_item', :as => :update_review_item
  match 'applicants/username_lookup/:id' => 'applicants#username_lookup', :as => :netid_lookup
  match 'logout' => 'access#logout', :as => :logout
  match '/:controller(/:action(/:id))'
end
