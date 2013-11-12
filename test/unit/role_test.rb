# == Schema Information
# Schema version: 20130511121216
#
# Table name: roles
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  name       :string(255)
#  updated_at :datetime
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  test "roles" do
    roles = Role.all

    assert !roles.nil? 
    assert roles.length > 0
    roles.each do |role|
      assert !role.blank?
    end
  end
  
end
