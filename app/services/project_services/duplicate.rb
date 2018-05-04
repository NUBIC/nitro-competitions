module ProjectServices
  module Duplicate
    def self.call(project_id)
      @project = Project.find(project_id).dup
      @project.write_attribute(:visible, false)
      @project.tap { |project| project.attribute_names.
        select{ |name| name.match? '_date' }.
          each{ |date| @project.write_attribute(date.to_sym, nil ) } }
    end
  end
end
