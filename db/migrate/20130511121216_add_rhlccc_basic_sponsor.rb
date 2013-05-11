class AddRhlcccBasicSponsor < ActiveRecord::Migration
  def self.up
    Program.create :program_title => "Robert H. Lurie Comprehensive Cancer Center Basic Sciences", :program_name => 'RHLCCC_basic', :program_url => "http://www.cancer.northwestern.edu"

    theProgram=Program.find_by_program_name("RHLCCC_basic")
    Project.create :project_title => "Basic Science Pilot Projects", 
      :project_url => "http://www.cancer.northwestern.edu/research/research_programs/basic_sciences/", 
      :project_name => "rhlccc_basic_pilots_2013",   # this is the SEO name - no spaces!
      :initiation_date => '07-MAY-2013',
      :submission_open_date => '21-MAY-2013',
      :submission_close_date => '04-MAY-2014',
      :review_start_date => '05-JUL-2013',
      :review_end_date => '04-MAY-2014',
      :project_period_start_date => '01-AUG-2013',
      :project_period_end_date => '31-JUL-2014',
      :program_id=> theProgram.id
  end

  def self.down
    theProgram=Program.find_by_program_name("RHLCCC_basic")
    theProjects=Project.find_all_by_program_id(theProgram.id)
    theProjects.each do |project|
      Project.delete(project.id)
    end
    Program.delete(theProgram.id)
  end

end
