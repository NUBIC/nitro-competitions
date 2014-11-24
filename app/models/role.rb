# encoding: UTF-8
# == Schema Information
# Schema version: 20141124223129
#
# Table name: roles
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  has_many :roles_users
  has_many :users, :through => :roles_users
  has_and_belongs_to_many :rights
  attr_accessible *column_names
  attr_accessible :rights
end
