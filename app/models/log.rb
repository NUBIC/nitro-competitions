# encoding: UTF-8

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
