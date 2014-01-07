# -*- coding: utf-8 -*-

require 'spec_helper'

describe ProjectsController do
  describe 'GET index' do
    it 'renders the page' do
      get :index
      response.should be_success
    end
    it 'assigns variables' do
      get :index
      assigns[:projects].should_not be_nil
    end
  end

  describe 'GET new' do
    context 'for a non-admin user' do
      it 'redirects to projects_path' do
        get :new
        response.should redirect_to(projects_path)
      end
    end
  end

  describe 'POST create' do
    context 'for a non-admin user' do
      it 'assigns variables' do
        post :create, :project => {}
        assigns[:project].should_not be_nil
      end
      it 'redirects to projects_path' do
        post :create, :project => {}
        response.should redirect_to(projects_path)
      end
    end
  end

  # describe 'GET show' do
  #   it 'renders the page' do
  #     project = FactoryGirl.create(:project)
  #     get :show, :id => project
  #     response.should be_success
  #   end
  # end

  # describe 'GET edit' do
  #   context 'for a non-admin user' do
  #     it 'redirects to the project_path' do
  #       project = FactoryGirl.create(:project)
  #       get :edit, :id => project
  #       response.should redirect_to(project_path(project))
  #     end
  #   end
  # end

  # test "should get edit" do
  #   get :edit, :id => projects(:one).to_param
  #   assert_response :redirect
  # end

  # test "should update project" do
  #   put :update, :id => projects(:one).to_param, :project => { }
  #   #assert_redirected_to project_path(assigns(:project))
  #   assert_response :success
  #   assert_template 'projects/show'
  # end

  # test "should destroy project" do
  #   assert_difference('Project.count', 0) do
  #     delete :destroy, :id => projects(:one).to_param
  #   end
  #   assert_not_nil assigns(:project)

  #   assert_redirected_to projects_path
  # end


end