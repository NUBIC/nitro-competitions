# encoding: UTF-8
# == Schema Information
# Schema version: 20130511121216
#
# Table name: roles_users
#
#  created_at :datetime
#  created_id :integer
#  created_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  id         :integer          not null, primary key
#  program_id :integer
#  role_id    :integer
#  updated_at :datetime
#  updated_id :integer
#  updated_ip :string(255)
#  user_id    :integer
#

class RolesUser < ActiveRecord::Base
  belongs_to :program
  belongs_to :user
  belongs_to :role
  has_many :rights, :through => :role
  attr_accessible *column_names
  attr_accessible :program, :user, :role

  scope :for_role, lambda { |*args| where('role_id = :id', { :id => args.first || 0 }) }
  scope :for_program, lambda { |*args| where('program_id = :id', { :id => args.first || 0 }) }
  scope :admins, joins(:role).where("roles.name = 'Admin'")

  validates_uniqueness_of :user_id, :scope => [:program_id, :role_id]
  validates_presence_of :user_id
  validates_presence_of :program_id
  validates_presence_of :role_id

end
