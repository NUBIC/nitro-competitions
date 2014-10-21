# encoding: UTF-8
# == Schema Information
# Schema version: 20140908190758
#
# Table name: reviewers
#
#  created_at :datetime         not null
#  created_id :integer
#  created_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  id         :integer          not null, primary key
#  program_id :integer
#  updated_at :datetime         not null
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
