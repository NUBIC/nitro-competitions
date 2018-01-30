# encoding: UTF-8

class Role < ActiveRecord::Base

  ADMIN       = 'Admin'
  READ_ONLY   = 'Full Read-only Access'
  VALID_ROLES = [ADMIN, READ_ONLY]

  has_many :roles_users
  has_many :users, through: :roles_users
  has_and_belongs_to_many :rights

  def self.admin
    where(name: Role::ADMIN).first_or_create
  end

  def self.read_only
    where(name: Role::READ_ONLY).first_or_create
  end
end
