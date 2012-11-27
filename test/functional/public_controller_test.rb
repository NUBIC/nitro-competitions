require 'test_helper'

class PublicControllerTest < ActionController::TestCase
  test "should get welcome" do
    get :welcome
    assert_response :success
    assert_not_nil assigns(:projects)
    assert_template 'public/welcome'
  end

  test "should get disallowed" do
    get :disallowed
    assert_response :success
    assert_template 'public/disallowed'
  end

end
