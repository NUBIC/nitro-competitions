class Project::Duplication < ApplicationRecord
  # DO_NOT_DUPLICATE = ['visible'].freeze

  def self.clear_duplication_attributes(original_project)
    project = original_project.dup
    project.write_attribute(:project_name, 'asdf')
    project
    # DO_NOT_DUPLICATE.each do |attribute|
    #   @project.write_attribute(attribute.to_sym, false)
    # end
  end

end
