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
