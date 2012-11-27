require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :sponsor_id=>programs(:one)
    assert_response :redirect
    assert_not_nil assigns(:sponsor)
    assert_nil assigns(:roles)
  end


  test "should show role" do
    get :show, {:sponsor_id=>programs(:one), :id => roles(:one).to_param}
    assert_response :redirect
    assert_not_nil assigns(:sponsor)
    assert_nil assigns(:roles)
  end

  test "should get add" do
    get :add, {:sponsor_id=>programs(:one), :role_id => roles(:one).to_param}
    assert_response :redirect
    assert_not_nil assigns(:sponsor)
    assert_not_nil assigns(:role)
  end

  test "should remove role" do
    assert_difference('Role.count', 0) do
      delete :remove, {:sponsor_id=>programs(:one), :id => roles_users(:one).to_param, :role_id => roles(:one).to_param}
    end
    assert_not_nil assigns(:sponsor)
    assert_not_nil assigns(:roles_user)
    assert_nil assigns(:role)
    assert_nil assigns(:roles)

    assert_redirected_to sponsor_role_url(:sponsor_id=>programs(:one), :id=>roles(:one))
  end
end
