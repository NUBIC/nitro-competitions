# == Schema Information
# Schema version: 20130511121216
#
# Table name: rights
#
#  action     :string(255)
#  controller :string(255)
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime
#

class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles
  attr_accessible *column_names
end
