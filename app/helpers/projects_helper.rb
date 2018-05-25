# -*- coding: utf-8 -*-

module ProjectsHelper
  def show_project_docs?(project)
    project_docs = ['application_template',
                    'application_info',
                    'budget_template',
                    'budget_info']
    return true if project_docs.any? { |doc| project.send("#{doc}_url").present? }
    return true if (project.rfa_url.present? && (project.rfa_url != project.project_url))
    return false
  end
end
