class PublicController < ActionController::Base
  # GET /public
  # GET /public.xml

  include ApplicationHelper
  include RolesHelper
 

  def welcome
    @projects = (Project.active).flatten.uniq
    clear_session_attributes()
    @current_user_session = nil
  end

  def disallowed 
    clear_session_attributes()
    @current_user_session = nil
  end

end
