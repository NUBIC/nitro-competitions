# -*- coding: utf-8 -*-
#
# Unauthorized controller for welcome page.
# All session attributes are cleared and user session
# is nullified.
class PublicController < ApplicationController
  include ApplicationHelper
  include RolesHelper

  before_filter :clear_session

  def welcome
    @projects = (Project.preinitiation + Project.open + Project.in_review + Project.recently_awarded).flatten.uniq
    @programs = {}
    @projects.each do |pr|
      @programs.keys.include?(pr.program) ? @programs[pr.program] << pr : @programs[pr.program] = [pr]
    end
  end

  def auth
    redirect_to "#{provider_site}?client_id=#{client_id}&client_secret=#{client_secret}"
  end

  def disallowed
  end

private
  def clear_session
    clear_session_attributes
    @current_user_session = nil
  end
end
