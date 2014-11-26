# encoding: UTF-8
class Role < ActiveRecord::Base
  has_many :roles_users
  has_many :users, :through => :roles_users
  has_and_belongs_to_many :rights
  attr_accessible *column_names
  attr_accessible :rights
end
