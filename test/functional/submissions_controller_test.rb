require 'test_helper'

class SubmissionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:submissions)
  end

  test "should fail to get new" do
    get :new
    assert_response :redirect
  end

  test "should not create submission redirect to projects" do
    assert_difference('Submission.count', 0) do
      post :create, :submission => { }
    end
    assert_not_nil assigns(:submission)
    assert_nil assigns(:applicant)
    assert_nil assigns(:project)

    assert_redirected_to projects_path
  end

  test "should not create submission redirect to project one" do
    assert_difference('Submission.count', 0) do
      post :create, {:project_id => projects(:one).to_param, :submission => { :project_id => projects(:one).to_param, :submission_title=>'this is a test', :direct_project_cost=>5000} }
    end
    assert_not_nil assigns(:submission)
    assert_nil assigns(:applicant)
    assert_not_nil assigns(:project)

    assert_same assigns(:project).id, projects(:one).id

    assert_redirected_to project_path(projects(:one).to_param)
  end

  test "should create valid submission" do
    post :create, {:project_id => projects(:one).to_param, :applicant_id => users(:one).to_param, :submission => { :project_id => projects(:one).to_param, :submission_title=>'this is a test', :direct_project_cost=>5000} }
    assert_not_nil assigns(:submission)
    assert_not_nil assigns(:applicant)
    assert_not_nil assigns(:project)
    assert assigns(:submission).valid? 
  end

  test "should create submission" do
    assert_difference('Submission.count') do
      post :create, {:project_id => projects(:one).to_param, :applicant_id => users(:one).to_param, :submission => { :project_id => projects(:one).to_param, :submission_title=>'this is a test', :direct_project_cost=>5000} }
    end
    assert_not_nil assigns(:submission)
    assert_not_nil assigns(:applicant)
    assert_not_nil assigns(:project)

    assert_response :success
    assert_not_nil assigns(:project)
    assert_template 'submissions/edit_documents'
  end

  test "should show submission" do
    get :show, :id => submissions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => submissions(:one).to_param
    assert_response :success
  end

  test "should update submission" do
    put :update, :id => submissions(:one).to_param, :submission => { }
    assert_response :redirect
    assert_redirected_to project_path(submissions(:one).project_id)
  end

  test "should not destroy submission" do
    # need to be owner
    assert_difference('Submission.count', 0) do
      delete :destroy, :id => submissions(:one).to_param
    end

    assert_redirected_to project_path(submissions(:one).project_id)
  end
end
