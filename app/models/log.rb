class Log < ActiveRecord::Base
  belongs_to :project
  belongs_to :program
  belongs_to :user
  
  named_scope :logins, :conditions => ["activity = 'login'"]
  named_scope :submissions, :conditions => ["activity LIKE '%%submission%%'"]  #need to escape the % with itself!
  named_scope :reviews, :conditions => ["activity LIKE '%%review%%'"]
  default_scope :include => [:user, :project, :program]
  
end
