# == Schema Information
# Schema version: 20130511121216
#
# Table name: logs
#
#  action_name     :string(255)
#  activity        :string(255)
#  controller_name :string(255)
#  created_at      :datetime
#  created_ip      :string(255)
#  id              :integer          not null, primary key
#  params          :text
#  program_id      :integer
#  project_id      :integer
#  updated_at      :datetime
#  user_id         :integer
#

require 'test_helper'

class LogTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
