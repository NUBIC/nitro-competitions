# -*- coding: utf-8 -*-
#
# Unauthorized controller for welcome page.
# All session attributes are cleared and user session
# is nullified.
class PublicController < ActionController::Base
  include ApplicationHelper
  include RolesHelper

  before_filter :clear_session

  ##
  # This is the application root path
  # GET /public/welcome
  # GET /
  def welcome
    @projects = (Project.preinitiation + Project.open + Project.in_review + Project.recently_awarded).flatten.uniq
    @programs = {}
    @projects.each do |pr|
      @programs.keys.include?(pr.program) ? @programs[pr.program] << pr : @programs[pr.program] = [pr]
    end
  end

  def disallowed
  end

  def clear_session
    clear_session_attributes
    @current_user_session = nil
  end
  private :clear_session

end
