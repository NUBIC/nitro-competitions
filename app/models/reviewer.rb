# encoding: UTF-8
# == Schema Information
#
# Table name: reviewers
#
#  id         :integer          not null, primary key
#  program_id :integer
#  user_id    :integer
#  created_id :integer
#  created_ip :string(255)
#  updated_id :integer
#  updated_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Reviewer < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  attr_accessible *column_names
  attr_accessible :user, :program
end

76
