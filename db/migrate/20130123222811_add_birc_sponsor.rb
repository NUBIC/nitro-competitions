class AddBircSponsor < ActiveRecord::Migration
  def self.up
    Program.create :program_title => "Bioinformatics Research Collaboratory", :program_name => 'BIRC', :program_url => "http://www.feinberg.northwestern.edu/research/cores/units/bioinformatics.html"

    theProgram=Program.find_by_program_name("BIRC")
    Project.create :project_title => "Cancer Bioinformatics Pilot Data Analysis Seed Grant", 
      :project_url => "http://www.feinberg.northwestern.edu/research/cores/units/bioinformatics.html", 
      :project_name => "birc_seed_2013",   # this is the SEO name - no spaces!
      :initiation_date => '22-JAN-2013',
      :submission_open_date => '26-JAN-2013',
      :submission_close_date => '01-MAR-2013',
      :review_start_date => '04-MAR-2013',
      :review_end_date => '14-MAR-2013',
      :project_period_start_date => '15-MAR-2013',
      :project_period_end_date => '14-MAR-2014',
      :program_id=> theProgram.id
  end

  def self.down
    theProgram=Program.find_by_program_name("BIRC")
    theProjects=Project.find_all_by_program_id(theProgram.id)
    theProjects.each do |project|
      Project.delete(project.id)
    end
    Program.delete(theProgram.id)
  end
end
