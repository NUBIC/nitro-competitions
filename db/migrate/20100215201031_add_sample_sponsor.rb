class AddSampleSponsor < ActiveRecord::Migration
  def self.up

    Program.create :program_title => "Example Competition Sponsor", :program_name => 'ECS', :program_url => "https://github.com/NUBIC"

    program = Program.find_by_program_name("ECS")
    Project.create :project_title => "Fall Pilot Grant competition", 
      :project_url => "http://www.nucats.northwestern.edu/pilots/index.html", 
      :project_name => "fall_2012_pilot",   # this is the SEO name - no spaces!
      :initiation_date => '02-NOV-2012',
      :submission_open_date => '02-NOV-2012',
      :submission_close_date => '04-DEC-2013',
      :review_start_date => '04-DEC-2013',
      :review_end_date => '08-JAN-2014',
      :project_period_start_date => '01-MAR-2014',
      :project_period_end_date => '28-FEB-2015',
      :program_id => program.id
  end

  def self.down
    program = Program.find_by_program_name("ECS")
    projects = Project.find_all_by_program_id(program.id)
    projects.each { |project| Project.delete(project.id) }
    Program.delete(program.id)
    
  end
end
