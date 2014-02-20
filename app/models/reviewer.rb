# encoding: UTF-8
# == Schema Information
# Schema version: 20130511121216
#
# Table name: reviewers
#
#  created_at :datetime
#  created_id :integer
#  created_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  id         :integer          not null, primary key
#  program_id :integer
#  updated_at :datetime
#  updated_id :integer
#  updated_ip :string(255)
#  user_id    :integer
#

class Reviewer < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  attr_accessible *column_names
  attr_accessible :user, :program
end
