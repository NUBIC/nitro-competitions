# -*- coding: utf-8 -*-

# Migration to add Department of Medical Social Sciences as Program
class AddMssSponsor < ActiveRecord::Migration
  def up
    program = Program.create program_title: 'Department of Medical Social Sciences',
                             program_name: 'MSS',
                             program_url: 'http://www.mss.northwestern.edu/'

    project = Project.new project_title: 'NU-PATIENT K12',
                          project_url: 'http://www.mss.northwestern.edu/',
                          project_name: 'nu_patient_k12',  # this is the SEO name - no spaces!
                          initiation_date: '01-MAY-2014',
                          submission_open_date: '15-MAY-2014',
                          submission_close_date: '30-JUNE-2014',
                          review_start_date: '01-JULY-2014',
                          review_end_date: '30-JULY-2014',
                          project_period_start_date: '01-SEPT-2014',
                          project_period_end_date: '31-AUG-2015',
                          program_id: program.id
    project.save!

    create_admins_for_program(program)
  end

  def create_admins_for_program(program)
    [
      %w(jka504 Julie Kay julie-kay@northwestern.edu),
      %w(dej892 Dennis Smith dennis-smith@northwestern.edu),
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
    program = Program.where(program_name: 'MSS').first
    if program
      program.projects.each { |project| Project.delete(project.id) }
      Program.delete(program.id)
    end
  end
end
