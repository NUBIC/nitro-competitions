class PublicController < ActionController::Base
  # GET /public
  # GET /public.xml

  include ApplicationHelper
  include RolesHelper


  def welcome
    @projects = (Project.preinitiation + Project.open + Project.in_review + Project.recently_awarded).flatten.uniq

    clear_session_attributes
    @current_user_session = nil
  end

  def disallowed
    clear_session_attributes
    @current_user_session = nil
  end

end
