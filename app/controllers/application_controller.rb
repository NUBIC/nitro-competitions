# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: [:welcome], unless: :devise_controller?
  # except: [:welcome] unless Rails.env == 'test'

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  
  protect_from_forgery with: :exception

  def authenticate_user!
    unless (ldap_user_signed_in? || external_user_signed_in?)
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to new_session_url
    end
  end

  # def authenticate_user!
  #   unless user_signed_in?
  #     flash[:alert] = 'redirected from authenticate_user! - application_controller.rb'
  #     redirect_to projects_url
  #   end
  # end

  def after_sign_in_path_for(resource)
    '/public/welcome' || root_path
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:username, 
                      :password,
                      :email,
                      :first_name,
                      :last_name)
    end

    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, 
                      :password,
                      :email)
    end

    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(:username, 
                      :password,
                      :email,
                      :password_confirmation,
                      :current_password)
    end
  end


  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include RolesHelper
  include ApplicationHelper

#   # make these accessible in a view
  helper_method :current_user_session

#   require 'ldap_utilities' # specific ldap methods
#   require 'config' # adds program_name method

#   after_action :log_request, except: [:login, :sign_in, :username_lookup, :lookup, :welcome, :update_item,
#                                       :add_user, :remove_user, :add_key_personnel, :remove_key_personnel,
#                                       :personnel_data, :applicant_data, :application_data, :key_personnel_data, :submission_data,
#                                       :reviewer_data, :review_data, :login_data]

#   before_action :authenticate_user!, except: [:welcome] unless Rails.env == 'test'

#   # for lograge
  # cf. http://ionrails.com/2013/03/26/how-to-add-the-request-parameters-along-with-full-url-request-in-lograge-outputted-files/
  def append_info_to_payload(payload)
    super
    payload['params'] = request.params
  end

  def get_client_ip
    request.remote_ip
  end

  def get_host_ip
    request.env['REMOTE_HOST']
  end

  def set_user_session(the_user)
    set_session_attributes(the_user) if the_user.username == current_user.try(:username)
  end

  def check_authorization
    user = current_user_session || current_user
    unless user.roles.find { |role|
      role.rights.find { |right|
        right.action == action_name && right.controller == self.class.controller_path
        }
      }
      flash[:notice] = 'You are not authorized to view the page you requested'
      request.env['HTTP_REFERER'] ? (redirect_back) : (redirect_to home_url)
      return false
    end
  end
  private :check_authorization

  def current_user_session
    return @current_user_session if current_user_session_exists?
    set_current_user_session unless current_user.blank?
    @current_user_session = User.new(username: '') unless current_user_session_exists?
    @current_user_session
  end
  private :current_user_session

  def current_user_session_exists?
    defined?(@current_user_session) && !@current_user_session.blank? && !@current_user_session.id.blank?
  end
  private :current_user_session_exists?

  def set_current_user_session
    @current_user_session = nil
    username = session[:username] || current_user.try(:username)
    begin
      @current_user_session = User.find_by_username(username)
    rescue
      Rails.logger.error("Could not find User with username: #{username.inspect}")
    end
  end
  private :set_current_user_session

  # before_action :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  # def ensure_signup_complete
  #   # Ensure we don't go into an infinite loop
    # return if action_name == 'finish_signup'

  #   # Redirect to the 'finish_signup' page if the user
  #   # email hasn't been verified yet
  #   if current_user && !current_user.email_verified?
  #     redirect_to finish_signup_path(current_user)
  #   end
  # end
end
