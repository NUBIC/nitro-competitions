# encoding: UTF-8
class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles
  attr_accessible *column_names
  attr_accessible :roles
end
