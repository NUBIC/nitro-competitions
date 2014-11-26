# encoding: UTF-8
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
