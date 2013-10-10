# == Schema Information
# Schema version: 20130511121216
#
# Table name: logs
#
#  action_name     :string(255)
#  activity        :string(255)
#  controller_name :string(255)
#  created_at      :datetime
#  created_ip      :string(255)
#  id              :integer          not null, primary key
#  params          :text
#  program_id      :integer
#  project_id      :integer
#  updated_at      :datetime
#  user_id         :integer
#

class Log < ActiveRecord::Base
  belongs_to :project
  belongs_to :program
  belongs_to :user
  
  named_scope :logins, :conditions => ["activity = 'login'"]
  named_scope :submissions, :conditions => ["activity LIKE '%%submission%%'"]  #need to escape the % with itself!
  named_scope :reviews, :conditions => ["activity LIKE '%%review%%'"]
  #default_scope :include => [:user, :project, :program]
  
end
