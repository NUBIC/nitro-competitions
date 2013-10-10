# == Schema Information
# Schema version: 20130511121216
#
# Table name: roles_users
#
#  created_at :datetime
#  created_id :integer
#  created_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  id         :integer          not null, primary key
#  program_id :integer
#  role_id    :integer
#  updated_at :datetime
#  updated_id :integer
#  updated_ip :string(255)
#  user_id    :integer
#

require 'test_helper'

class RolesUserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  test "roles_users aassigned to users" do
    roles_users = RolesUser.all

    assert !roles_users.nil? 
    assert roles_users.length > 0
    roles_users.each do |ru|
      assert !ru.role.blank?
      assert !ru.user.blank?
     end
  end
  
end
