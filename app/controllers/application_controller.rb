# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include RolesHelper
  include ApplicationHelper

  # make these accessible in a view
  helper_method :current_user_session

  require 'ldap_utilities' # specific ldap methods
  require 'config' # adds program_name method

  before_filter :check_ips, except: [:check_ips, :disallowed, :welcome]
  # before_filter :check_session, except: [:login, :welcome] unless Rails.env == 'test'
  before_filter :login_required, except: [:login, :welcome] unless Rails.env == 'test'

  after_filter :log_request, except: [:login, :username_lookup, :lookup, :welcome, :update_item,
                                      :add_user, :remove_user, :add_key_personnel, :remove_key_personnel,
                                      :personnel_data, :applicant_data, :application_data, :key_personnel_data, :submission_data,
                                      :reviewer_data, :review_data, :login_data]

  ##
  # For authorization using lib/nucats_membership.rb
  # as omniauth authority
  def login_required
    redirect_to '/auth/nucatsmembership' unless current_user
  end

  ##
  # Check the session for user_info
  # @return [User]
  def current_user
    return nil unless session[:user_info]
    @current_user ||= User.where(email: session[:user_info]['info']['email']).first
  end

  def check_ips
    redirect_to controller: 'public', action: 'disallowed' if disallowed_ip(get_client_ip)
  end

  def get_client_ip
    request.remote_ip
  end

  def get_host_ip
    request.env['REMOTE_HOST']
  end

  def set_user_session(the_user)
    set_session_attributes(the_user) if the_user.username == current_user.username
  end

  private

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
    username = session[:username] || current_user.username
    begin
      @current_user_session = User.find_by_username(username)
    rescue
      Rails.logger.error("Could not find User with username: #{username}")
    end
  end
  private :set_current_user_session

end
