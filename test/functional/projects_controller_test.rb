require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :redirect
  end

  test "should fail on create project" do
    assert_difference('Project.count', 0) do
      post :create, :project => {}
    end
    assert_not_nil assigns(:project)
    assert_response :redirect
    assert_redirected_to projects_path
  end

  test "should create project" do
    assert_difference('Project.count', 0) do
      post :create, :project => {:project_title=>'new project', :project_name=> 'this2011' }
    end

    assert_not_nil assigns(:project)
    assert_response :redirect
    assert_redirected_to projects_path
  end

  test "should show project" do
    get :show, :id => projects(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => projects(:one).to_param
    assert_response :redirect
  end

  test "should update project" do
    put :update, :id => projects(:one).to_param, :project => { }
    #assert_redirected_to project_path(assigns(:project))
    assert_response :success
    assert_template 'projects/show'
  end

  test "should destroy project" do
    assert_difference('Project.count', 0) do
      delete :destroy, :id => projects(:one).to_param
    end
    assert_not_nil assigns(:project)

    assert_redirected_to projects_path
  end
end
