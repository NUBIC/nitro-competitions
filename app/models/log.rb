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

  scope :logins, where("activity = 'login'")
  scope :submissions, where("activity LIKE '%%submission%%'")  #need to escape the % with itself!
  scope :reviews, where("activity LIKE '%%review%%'")

  attr_accessible *column_names

end
