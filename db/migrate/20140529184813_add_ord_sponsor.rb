# -*- coding: utf-8 -*-

# Migration to add Office for Research Development
class AddOrdSponsor < ActiveRecord::Migration
  def up
    program = Program.create program_title: 'Office for Research Development',
                             program_name: 'ORD',
                             program_url: 'http://www.research.northwestern.edu/ord/'

    project = Project.new project_title: 'ORD Pilot Project',
                          project_url: 'http://www.research.northwestern.edu/ord/',
                          project_name: 'ord_pilot_2014',  # this is the SEO name - no spaces!
                          initiation_date: '01-JUNE-2014',
                          submission_open_date: '15-JUNE-2014',
                          submission_close_date: '31-JULY-2014',
                          review_start_date: '01-AUG-2014',
                          review_end_date: '31-AUG-2014',
                          project_period_start_date: '01-SEPT-2014',
                          project_period_end_date: '31-AUG-2015',
                          program_id: program.id
    project.save!

    create_admins_for_program(program)
  end

  def create_admins_for_program(program)
    [
      %w(fye745 Fruma Yehiely yehiely@northwestern.edu),
      %w(klc201 Karen Cielo k-cielo@northwestern.edu),
      %w(amz203 Aleksandra Mechetner aleksandra.mechetner@northwestern.edu),
      %w(pfr957 Paul Friedman p-friedman@northwestern.edu),
    ].each do |arr|
      user = find_or_create_user(arr)
      admin = Role.where(name: 'Admin').first
      if admin && user && program
        ru = RolesUser.new
        ru.user = user
        ru.role = admin
        ru.program = program
        ru.save!
      end
    end
  end

  def find_or_create_user(arr)
    user = User.where(username: arr[0]).first
    if user.blank?
      user = User.create username: arr[0],
                         first_name: arr[1],
                         last_name: arr[2],
                         email: arr[3]
    end
    user
  end

  def down
    program = Program.where(program_name: 'ORD').first
    if program
      program.projects.each { |project| Project.delete(project.id) }
      Program.delete(program.id)
    end
  end
end
