# encoding: UTF-8

class RolesUser < ApplicationRecord
  belongs_to :program
  belongs_to :user
  belongs_to :role
  has_many :rights, :through => :role
  
  def self.for_role(*args) 
    where('role_id = :id', { :id => args.first || 0 })
  end
  
  def self.for_program(*args) 
    where('program_id = :id', { :id => args.first || 0 })
  end
  
  def self.admins 
    joins(:role).where("roles.name = 'Admin'")
  end

  def self.read_only
    joins(:role).where("roles.name = 'Full Read-only Access'")
  end

  validates_uniqueness_of :user_id, :scope => [:program_id, :role_id]
  validates_presence_of :user_id
  validates_presence_of :program_id
  validates_presence_of :role_id

end
