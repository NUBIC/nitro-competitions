module ProjectServices
  module Duplicate
    def self.call(project_id)
      @project = Project.find(project_id).dup
      update_rfa_url if @project.rfa_url.match? project_id
      @project.write_attribute(:visible, false)
      @project.tap { |project| project.attribute_names.
        select{ |name| name.match? '_date' }.
          each{ |date| @project.write_attribute(date.to_sym, nil ) } }
    end

    private
    def self.update_rfa_url
      @project.write_attribute(:rfa_url, '')
    end

  end
end
