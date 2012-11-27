class RolesUser < ActiveRecord::Base
  belongs_to :program
  belongs_to :user
  belongs_to :role
  has_many :rights, :through => :role
  
  named_scope :for_role, lambda { |*args| {:conditions => [ 'role_id = :id', {:id => args.first || 0 } ] } }
  named_scope :for_program, lambda { |*args| {:conditions => [ 'program_id = :id', {:id => args.first || 0 } ] } }
  named_scope :admins,  :joins => :role, :conditions => [ "roles.name = 'Admin'"]
  
  validates_uniqueness_of :user_id, :scope => [:program_id, :role_id]
  validates_presence_of :user_id
  validates_presence_of :program_id
  validates_presence_of :role_id
  
end
