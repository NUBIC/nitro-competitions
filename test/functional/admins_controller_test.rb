require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get(:index, {'project_id' => "1"})
    assert_response :redirect
    assert_not_nil assigns(:sponsor)
    assert_nil assigns(:submissions)
    assert_redirected_to projects_path
  end

  test "should get view_activities" do
    get(:view_activities, {'project_id' => "1"})
    assert_response :redirect
  end

  test "should show submissions" do
    get :submissions, :project_id => "1"
    assert_response :redirect
  end

  test "should update reviews" do
    put :reviews, :project_id => "1"
    assert_response :redirect
  end

  test "should get personnel_data" do
    get :personnel_data
    assert_response :success
  end

end
