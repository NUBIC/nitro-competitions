# encoding: UTF-8
# == Schema Information
#
# Table name: rights
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  controller :string(255)
#  action     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles
end
