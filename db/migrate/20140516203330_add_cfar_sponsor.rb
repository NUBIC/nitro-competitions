class AddCfarSponsor < ActiveRecord::Migration

  def up
    Program.create(:program_title => "Third Coast Center for AIDS Research ",
      :program_name => 'CFAR',
      :program_url => "http://www.chicagocfar.org/")

    program = Program.find_by_program_name("CFAR")
    proj = Project.new(:project_title => "HIV/AIDS Pilot Project Research Project",
      :project_url => "http://www.chicagocfar.org/pilotprojects",
      :project_name => "hiv_aids_pilot_2014",
      :initiation_date => '15-MAY-2014',
      :submission_open_date => '15-MAY-2014',
      :submission_close_date => '02-JUN-2014',
      :review_start_date => '15-JUN-2014',
      :review_end_date => '30-JUN-2014',
      :project_period_start_date => '01-JUL-2014',
      :project_period_end_date => '30-JUN-2015',
      :program_id => program.id)

    proj.save!
  end

  def down
    program = Program.find_by_program_name("CFAR")
    projects = Project.find_all_by_program_id(program.id)
    projects.each do |project|
      Project.delete(project.id)
    end
    Program.delete(program.id)
  end

end
