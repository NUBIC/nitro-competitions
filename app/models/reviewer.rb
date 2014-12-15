# encoding: UTF-8
class Reviewer < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  attr_accessible *column_names
  attr_accessible :user, :program
end
