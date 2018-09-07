# -*- coding: utf-8 -*-
class CompetitionsController < SecuredController
  include ApplicationHelper
  include RolesHelper

  def open
    @projects = Project.open.uniq.flatten.select { |p| p.visible == true }
    @programs = {}
    @projects.each do |pr|
      @programs.keys.include?(pr.program) ? @programs[pr.program] << pr : @programs[pr.program] = [pr]
    end
  end
end
