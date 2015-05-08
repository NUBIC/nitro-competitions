# encoding: UTF-8
# == Schema Information
#
# Table name: logs
#
#  id              :integer          not null, primary key
#  activity        :string(255)
#  user_id         :integer
#  program_id      :integer
#  project_id      :integer
#  controller_name :string(255)
#  action_name     :string(255)
#  params          :text
#  created_ip      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Log < ActiveRecord::Base
  belongs_to :project
  belongs_to :program
  belongs_to :user

  scope :logins, where("activity = 'login'")
  scope :submissions, where("activity LIKE '%%submission%%'")  #need to escape the % with itself!
  scope :reviews, where("activity LIKE '%%review%%'")

  attr_accessible *column_names
  attr_accessible :project, :program, :user
end
