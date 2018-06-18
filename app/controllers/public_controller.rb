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
      redirect_to home_path
    else
      @projects = Project.with_program.published.open
      @programs = @projects
                    .group_by { |project| project.program }
                      .sort_by  { |program, _| program[:program_title] }
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
