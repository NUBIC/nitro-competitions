# encoding: UTF-8
# == Schema Information
# Schema version: 20140908190758
#
# Table name: rights
#
#  action     :string(255)
#  controller :string(255)
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime         not null
#

class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles
  attr_accessible *column_names
  attr_accessible :roles
end
