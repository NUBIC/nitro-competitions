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

require 'test_helper'

class RightTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
