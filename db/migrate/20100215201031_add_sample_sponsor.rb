class AddSampleSponsor < ActiveRecord::Migration
  def self.up

    Program.create :program_title => "Example Competition Sponsor", :program_name => 'ECS', :program_url => "https://github.com/nubic"

    theProgram=Program.find_by_program_name("ECS")
    Project.create :project_title => "Fall Pilot Grant competition", 
      :project_url => "http://www.nucats.northwestern.edu/pilots/index.html", 
      :project_name => "fall_2012_pilot",   # this is the SEO name - no spaces!
      :initiation_date => '02-NOV-2012',
      :submission_open_date => '02-NOV-2012',
      :submission_close_date => '04-DEC-2012',
      :review_start_date => '04-DEC-2012',
      :review_end_date => '08-JAN-2013',
      :project_period_start_date => '01-MAR-2013',
      :project_period_end_date => '28-FEB-2014',
      :program_id=> theProgram.id
  end

  def self.down
    theProgram=Program.find_by_program_name("ECS")
    theProjects=Project.find_all_by_program_id(theProgram.id)
    theProjects.each do |project|
      Project.delete(project.id)
    end
    Program.delete(theProgram.id)
    
  end
end
