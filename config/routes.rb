ActionController::Routing::Routes.draw do |map|
  #sponsor is a rewording of program. program is really a 'project owner'
  # users have roles in a program
  
  map.resources :sponsors, :only=>[:index,:show,:edit,:update], :member => {:contact => :get} do |sponsors|
    sponsors.resources :roles, :only=>[:index,:show] do |roles|
      roles.resources :users, :only=>[] do |users|
        users.resources :rest, :only => [], :controller => :roles, :member => {:remove => [:get], :add => [:get]}
      end
    end
  end
  
  map.resources :file_documents, :only=>:show

  map.resources :projects do |projects|
    projects.resources :applicants do |applicants|
      applicants.resources :submissions, :only=>[:new,:create]
    end
    projects.resources :submissions, :only => :index
    projects.resources :approvers, :only=>[:index,:update]
    projects.resources :reviewers, :only=>[:index,:edit,:update,:destroy], :collection => {:all_reviews => :get, :complete_listing => :get, :complete_listing_with_files => :get, :index_with_files => :get}, :member => {:save_review_item => [:get,:post]}
    projects.resources :admins, :only=>:index, 
      :collection => {:reviews => :get, :view_applicants => :get, :view_activities => :get, :view_submissions => :get, :view_reviews => :get, :view_logins => :get, :reviewers => :get, :submissions => :get, :add_reviewers => :post, :unassign_submission => :post, :act_as_user=> [:get,:post]}, 
      :member => {:remove_reviewer => [:get,:post], :assign_submission => :post}
  end

  map.resources :submissions, 
      :except => :index, 
      :collection => {:all => :get}, 
      :member => {:reassign_applicant => [:get,:post], :update_key_personnel => [:put,:post], :edit_documents => [:get,:post]} do |submissions|
    submissions.resources :reviews, :only => [:index], :name_prefix => "submission_"
    submissions.resources :key_personnel, :except => :new, :collection => {:add_new => [:get,:post], :lookup => [:get,:post]}
  end

  map.resources :applicants, :except=>[:destroy]

  map.show_competition 'competitions/:program_name/:project_name', :controller => 'projects', :action => 'show'
  map.competitions 'competitions/:program_name', :controller => 'projects', :action => 'index'

  map.add_user_role 'role/:id/add_user/:user_id', :controller => 'roles', :action => 'add_user'
  map.remove_user_role 'role/:user_role_id/remove_user', :controller => 'roles', :action => 'remove_user'
#  map.create_submission 'applicant/:applicant_id/create/:id', :controller => 'submissions', :action => 'create'
#  map.create_applicant 'applicants/create/:id', :controller => 'applicants', :action => 'create'
  map.login_target 'projects', :controller => 'projects', :action => 'index'
#  map.add_key_personnel 'key_personnel/:id/add', :controller => 'submissions', :action => 'add_key_personnel'
#  map.remove_key_personnel 'key_personnel/:id/delete', :controller => 'submissions', :action => 'remove_key_personnel'
#  map.key_personnel_lookup 'key_personnel/:id/lookup', :controller => 'submissions', :action => 'key_personnel_lookup'
  map.update_review_item 'review/:id/update_item', :controller => 'reviews', :action => 'update_item'
  map.netid_lookup 'applicants/username_lookup/:id', :controller => 'applicants', :action => 'username_lookup'
  
  #for the amcharts graphs
  map.personnel_data 'personnel_data', :controller => 'admins', :action => 'personnel_data'
  map.applicant_data 'applicant_data', :controller => 'admins', :action => 'applicant_data'
  map.application_data 'application_data', :controller => 'admins', :action => 'application_data'
  map.key_personnel_data 'key_personnel_data', :controller => 'admins', :action => 'key_personnel_data'
  map.submission_data 'submission_data', :controller => 'admins', :action => 'submission_data'
  map.reviewer_data 'reviewer_data', :controller => 'admins', :action => 'reviewer_data'
  map.review_data 'review_data', :controller => 'admins', :action => 'review_data'
  map.login_data 'login_data', :controller => 'admins', :action => 'login_data'
  

  map.welcome 'welcome', :controller => "public", :action => 'welcome'
  map.root :controller => "public", :action => 'welcome'
  #relies on bcsec / aker
  map.logout 'logout', :controller => 'access', :action => 'logout'

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
