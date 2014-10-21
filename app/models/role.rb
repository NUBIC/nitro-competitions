# encoding: UTF-8
# == Schema Information
# Schema version: 20140908190758
#
# Table name: roles
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  has_many :roles_users
  has_many :users, :through => :roles_users
  has_and_belongs_to_many :rights
  attr_accessible *column_names
  attr_accessible :rights
end
