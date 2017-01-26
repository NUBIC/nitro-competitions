# encoding: UTF-8
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base

  ADMIN     = 'Admin'
  READ_ONLY = 'Full Read-only Access'

  has_many :roles_users
  has_many :users, :through => :roles_users
  has_and_belongs_to_many :rights

  def self.admin
    Role.where(name: ADMIN).first_or_create
  end

  def self.read_only
    Role.where(name: READ_ONLY).first_or_create
  end
end
