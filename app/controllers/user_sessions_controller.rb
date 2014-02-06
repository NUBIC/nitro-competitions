# -*- coding: utf-8 -*-
# Controller class to help with logging in and out of
# the application
class UserSessionsController < ApplicationController
  before_filter :login_required, only: [:destroy]

  respond_to :html

  # omniauth callback method
  def create
    # TODO: determine how often this method gets called
    omniauth = env['omniauth.auth']
    User.find_or_create_from_omniauth(omniauth)
    # Storing all the info
    session[:user_info] = omniauth
    flash[:notice] = 'Successfully logged in'
    redirect_to '/projects'
  end

  # Omniauth failure callback
  def failure
    flash[:notice] = params[:message]
  end

  # signout - Clear our rack session user_info
  def destroy
    session[:user_info] = nil
    flash[:notice] = 'You have successfully signed out!'
    redirect_to '/welcome'
  end
end
