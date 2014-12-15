# encoding: UTF-8
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
