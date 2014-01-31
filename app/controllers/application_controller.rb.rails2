# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include RolesHelper
  include ApplicationHelper
  
  include Aker::Rails::SecuredController unless Rails.env == 'test' 
  # include Bcsec::Rails::SecuredController unless Rails.env == 'test' 
  # pre 2.0 call include Bcsec::SecuredController
 
  # make these accessible in a view
  helper_method :current_user_session 
 
  require 'ldap_utilities' #specific ldap methods
  require 'config' #adds program_name method

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  

  before_filter  :check_ips, :except => [:check_ips, :disallowed, :welcome]
  before_filter(  :check_session, :except => [:login, :welcome]) unless Rails.env == 'test' 
  after_filter  :log_request, :except => [:login, :username_lookup, :add_user, :remove_user, :add_key_personnel, :remove_key_personnel, :lookup, :personnel_data, :applicant_data, :application_data, :key_personnel_data, :submission_data, :reviewer_data, :review_data, :login_data, :welcome, :update_item]
  #before_filter  :check_authorization, :except => [:login, :signin]


  def check_ips
   if disallowed_ip(get_client_ip()) then 
     redirect_to :controller => 'public', :action => 'disallowed'
   end
  end
  
   def get_client_ip
     request.remote_ip 
   end
   
   def get_host_ip
     request.env["REMOTE_HOST"] 
   end
   
   def set_user_session(the_user)
     set_session_attributes(the_user) if the_user.username == current_user.username
     #set_session_attributes(the_user) if the_user.username == current_user_session.username
   end

   private

   def check_authorization 
     user = current_user_session||current_user
     unless user.roles.detect { |role|
        role.rights.detect { |right| 
          right.action == action_name && right.controller == self.class.controller_path 
          }
       } 
       flash[:notice] = "You are not authorized to view the page you requested"
       request.env["HTTP_REFERER"] ? (redirect_to :back) : (redirect_to home_url)
       return false
     end
   end
   
   def current_user_session
     if (defined?(@current_user_session) and ! @current_user_session.blank?)
       return @current_user_session 
     end
     @current_user_session = nil
     begin
       @current_user_session = User.find_by_username(session[:username]||current_user.username) unless current_user.blank?
     rescue
     end
     @current_user_session = User.new(:username=>'') unless defined?(@current_user_session) and ! @current_user_session.blank? and !@current_user_session.id.blank?
     return @current_user_session
   end
     
end
