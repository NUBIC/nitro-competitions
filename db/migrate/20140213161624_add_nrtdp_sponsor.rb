# -*- coding: utf-8 -*-

# Migration to add National Resource for Translational and Developmental Proteomics as Program
class AddNrtdpSponsor < ActiveRecord::Migration
  def up
    program = Program.create program_title: 'National Resource for Translational and Developmental Proteomics',
                             program_name: 'NRDTP',
                             program_url: 'http://pce.northwestern.edu'

    project = Project.new project_title: 'Call for Collaborative Proposals in Top Down Proteomics',
                          project_url: 'http://pce.northwestern.edu',
                          project_name: 'top_down_proteomics',  # this is the SEO name - no spaces!
                          initiation_date: '01-FEB-2014',
                          submission_open_date: '20-FEB-2014',
                          submission_close_date: '20-MAR-2014',
                          review_start_date: '21-MAR-2014',
                          review_end_date: '04-MAY-2014',
                          project_period_start_date: '01-AUG-2014',
                          project_period_end_date: '31-JUL-2015',
                          program_id: program.id
    project.save!

    create_admins_for_program(program)
  end

  def create_admins_for_program(program)
    [
      %w(pmt706 Paul Thomas paul-thomas@northwestern.edu),
      %w(nlk432 Neil Kelleher n-kelleher@northwestern.edu),
      %w(hmt981 Haylee Thomas h-thomas@northwestern.edu),
      %w(pdc947 Phil Compton philip-compton@northwestern.edu),
      %w(int357 Ioanna Ntai i-ntai@northwestern.edu),
      %w(pfr957 Paul Friedman p-friedman@northwestern.edu),
    ].each do |arr|
      user = User.where(username: arr[0]).first
      if user.blank?
        user = User.create username: arr[0],
                           first_name: arr[1],
                           last_name: arr[2],
                           email: arr[3]
      end
      admin = Role.where(name: 'Admin').first
      RolesUser.create(program: program, user: user, role: admin) if admin && user && program
    end
  end

  def down
    program = Program.where(program_name: 'NRDTP').first
    if program
      program.projects.each { |project| Project.delete(project.id) }
      Program.delete(program.id)
    end
  end
end
