# -*- coding: utf-8 -*-
require 'spec_helper'

describe ProjectsController do

  context 'with a logged in user' do
    before do
      login(user_login)
    end

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
          post :create, project: {}
          assigns[:project].should_not be_nil
        end
        it 'redirects to projects_path' do
          post :create, project: {}
          response.should redirect_to(projects_path)
        end
      end
    end

    context 'with a logged in user' do
      before do
        login(user_login)
      end

      describe 'GET show' do
        it 'renders the page' do
          project = FactoryGirl.create(:project)
          get :show, id: project
          response.should be_success
        end
      end
    end

    describe 'GET edit' do
      context 'for a non-admin user' do
        it 'redirects to the project_path' do
          project = FactoryGirl.create(:project)
          get :edit, id: project
          response.should redirect_to(project_path(project))
        end
      end
    end

    describe 'PUT update' do
      context 'for a non-admin user' do
        it 'renders the show template' do
          project = FactoryGirl.create(:project)
          put :update, id: project, project: {}
          response.should render_template('projects/show')
        end
      end
    end

    describe 'DELETE destroy' do
      context 'for a non-admin user' do
        it 'redirects to the projects_path' do
          project = FactoryGirl.create(:project)
          delete :destroy, id: project
          assigns[:project].should_not be_nil
          response.should redirect_to(projects_path)
        end
      end
    end
  end
end
