# encoding: UTF-8
# == Schema Information
#
# Table name: roles_users
#
#  id         :integer          not null, primary key
#  role_id    :integer
#  user_id    :integer
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  created_id :integer
#  created_ip :string(255)
#  updated_id :integer
#  updated_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#

class RolesUser < ActiveRecord::Base
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

  validates_uniqueness_of :user_id, :scope => [:program_id, :role_id]
  validates_presence_of :user_id
  validates_presence_of :program_id
  validates_presence_of :role_id

end
