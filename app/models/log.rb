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

  def self.logins
    where("activity = 'login'")
  end
  def self.submissions
    #need to escape the % with itself!
    where("activity LIKE '%%submission%%'")  
  end
  def self.reviews
    where("activity LIKE '%%review%%'")
  end
end
