class AddIbnamSponsor < ActiveRecord::Migration
  def self.up
    Program.create :program_title => "Institute for BioNanotechnology in Medicine", :program_name => 'IBNAM', :program_url => "http://www.ibnam.northwestern.edu"

    theProgram=Program.find_by_program_name("IBNAM")
    Project.create :project_title => "Center for Regenerative Nanomedicine Catalyst Award", 
      :project_url => "http://www.ibnam.northwestern.edu", 
      :project_name => "nanomedicine_2013",   # this is the SEO name - no spaces!
      :initiation_date => '07-JAN-2013',
      :submission_open_date => '21-JAN-2013',
      :submission_close_date => '04-FEB-2013',
      :review_start_date => '05-FEB-2013',
      :review_end_date => '04-MAR-2013',
      :project_period_start_date => '01-APR-2013',
      :project_period_end_date => '31-MAR-2014',
      :program_id=> theProgram.id
  end

  def self.down
    theProgram=Program.find_by_program_name("IBNAM")
    theProjects=Project.find_all_by_program_id(theProgram.id)
    theProjects.each do |project|
      Project.delete(project.id)
    end
    Program.delete(theProgram.id)
  end
end
