# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include RolesHelper
  include ApplicationHelper

  include Aker::Rails::SecuredController unless Rails.application.config.use_omniauth

  # make these accessible in a view
  helper_method :current_user_session

  require 'ldap_utilities' # specific ldap methods
  require 'config' # adds program_name method

  after_filter :log_request, except: [:login, :username_lookup, :lookup, :welcome, :update_item,
                                      :add_user, :remove_user, :add_key_personnel, :remove_key_personnel,
                                      :personnel_data, :applicant_data, :application_data, :key_personnel_data, :submission_data,
                                      :reviewer_data, :review_data, :login_data]

  before_filter :authenticate_user, except: [:login, :welcome] unless Rails.env == 'test'
  before_filter :check_cookie unless Rails.env == 'test'
  def check_cookie
    unless cookie_valid?
      clear_session_attributes
      redirect_to root_path
    end
  end

  require 'net/http'
  def cookie_valid?
    cookies[:nucats_auth].present? && cookie_and_session_match
  end

  def cookie_and_session_match
    return false if current_user.blank?
    data = decrypt_cookie_data(cookies[:nucats_auth])
    vals = data.split(',')
    vals.include?(current_user.username) || vals.include?(current_user.email)
  end

  def decrypt_cookie_data(encrypted_data)
    begin
      crypt = ActiveSupport::MessageEncryptor.new(cookie_key)
      crypt.decrypt_and_verify(encrypted_data)
    rescue
      encrypted_data
    end
  end

  ##
  # With the addition of omniauth as a authentication mechanism, determine
  # the authentication method to use (aker or omniauth) based on the
  # `use_omniauth` configuration setting
  #
  # TODO: replace this with the preferred authentication mechanism once the
  #       stakeholders choose which method to use
  def authenticate_user
    Rails.application.config.use_omniauth ? login_required : check_session
  end

  ##
  # If using omniauth, check the session for user_info
  # otherwise return the Aker user
  #
  # TODO: replace this with the preferred authentication mechanism once the
  #       stakeholders choose which method to use
  # @return [User]
  def current_user
    if Rails.application.config.use_omniauth
      return nil unless session[:user_info]
      @current_user ||= User.find_user_from_omniauth(session[:user_info])
    else
      request.env['aker.check'].user
    end
  end

  ##
  # For authorization using lib/nucats_membership.rb
  # as omniauth authority
  def login_required
    not_authorized unless current_user
  end

  def not_authorized
    respond_to do |format|
      format.html{ auth_redirect }
      format.json{ head :unauthorized }
    end
  end

  def auth_redirect
    redirect_to "/auth/nucatsaccounts?origin=#{request_origin}"
  end
  private :auth_redirect

  def request_origin
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end
  private :request_origin

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
      request.env['HTTP_REFERER'] ? (redirect_to :back) : (redirect_to home_url)
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

end
