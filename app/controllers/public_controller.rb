# -*- coding: utf-8 -*-
#
# Unauthorized controller for welcome page.
# All session attributes are cleared and user session
# is nullified.

# TODO: This should inherit from the ApplicationController, which means the
# authentication/authorization needs to be de-coupled from this as well. If I
# change it now the authorization for the public views breaks because by
# default, everything on the ApplicationController requires an active session.
class PublicController < ApplicationController
  include ApplicationHelper
  include RolesHelper

  layout 'application'

  def welcome
    if current_user
      redirect_to '/public/home'
    else
      @projects = Project.open.uniq.select { |p| p.visible == true }

      @programs = {}
      @projects.each do |pr|
        @programs.keys.include?(pr.program) ? @programs[pr.program] << pr : @programs[pr.program] = [pr]
      end
    end
  end

  def home
    # TODO: look for better way to get all unique submissions for current user
    @submissions        = (current_user.submissions + current_user.proxy_submissions).uniq
    @submission_reviews = current_user.submission_reviews
  end

  def auth
    redirect_to '/users/login'
  end

  def disallowed
  end
end
