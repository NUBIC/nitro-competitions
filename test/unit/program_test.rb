# == Schema Information
# Schema version: 20130511121216
#
# Table name: programs
#
#  created_at    :datetime
#  created_id    :integer
#  created_ip    :string(255)
#  deleted_at    :datetime
#  deleted_id    :integer
#  deleted_ip    :string(255)
#  id            :integer          not null, primary key
#  program_name  :string(255)
#  program_title :string(255)
#  program_url   :string(255)
#  updated_at    :datetime
#  updated_id    :integer
#  updated_ip    :string(255)
#

require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
