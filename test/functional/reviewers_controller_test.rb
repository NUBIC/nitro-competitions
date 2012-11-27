require 'test_helper'

class ReviewersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assigned_submission_reviews)
  end


  test "should get edit" do
    get :edit, :id => reviewers(:one).to_param
    assert_response :redirect
  end

  test "should update reviewer" do
    put :update, :id => reviewers(:one).to_param, :reviewer => { }
    assert_redirected_to project_reviewers_url(projects(:one))
  end

  test "should destroy reviewer" do
    # won't work as must be admin
    assert_difference('Reviewer.count', 0) do
      delete :destroy, :id => reviewers(:one).to_param
    end

    assert_redirected_to project_reviewers_path(projects(:one))
  end
end
