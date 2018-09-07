class SecuredController < ApplicationController
  before_action :authenticate_user!, :require_user

  def require_user
    unless current_user
      #store_location
      # current_user.nil? ? flash[:notice] = "Please login to access this page" : flash[:error] = "Access Denied"
      current_user.nil? ? (redirect_to new_session_url) : (redirect_to welcome_url)
      return false
    end
  end
end