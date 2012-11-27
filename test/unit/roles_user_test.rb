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
