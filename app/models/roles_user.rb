# encoding: UTF-8

class RolesUser < ActiveRecord::Base
  belongs_to :program
  belongs_to :user
  belongs_to :role
  has_many :rights, through: :role

  validates_uniqueness_of :user, scope: [:program, :role]
  validates_presence_of :user
  validates_presence_of :program
  validates_presence_of :role
  
  def self.for_role(*args) 
    where('role_id = :id', { id: args.first || 0 })
  end
  
  def self.for_program(*args) 
    where('program_id = :id', { id: args.first || 0 })
  end
  
  def self.admins 
    joins(:role).where(roles: {name: Role::ADMIN})
  end

  def self.read_only
    joins(:role).where(roles: {name: Role::READ_ONLY})
  end
end
