# -*- coding: utf-8 -*-
require 'spec_helper'

describe ProjectsController, :type => :controller do

  context 'with a logged in user' do
    before do
      login(user_login)
    end

    describe 'GET index' do
      it 'renders the page' do
        get :index
        expect(response).to be_success
      end
      it 'assigns variables' do
        get :index
        expect(assigns[:projects]).not_to be_nil
      end
    end

    describe 'GET new' do
      context 'for a non-admin user' do
        it 'redirects to projects_path' do
          get :new
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    describe 'POST create' do
      context 'for a non-admin user' do
        it 'assigns variables' do
          post :create, project: {}
          expect(assigns[:project]).not_to be_nil
        end
        it 'redirects to projects_path' do
          post :create, project: {}
          expect(response).to redirect_to(projects_path)
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
          expect(response).to be_success
        end
      end
    end

    describe 'GET edit' do
      context 'for a non-admin user' do
        it 'redirects to the project_path' do
          project = FactoryGirl.create(:project)
          get :edit, id: project
          expect(response).to redirect_to(project_path(project))
        end
      end
    end

    describe 'PUT update' do
      context 'for a non-admin user' do
        it 'renders the show template' do
          project = FactoryGirl.create(:project)
          put :update, id: project, project: {}
          expect(response).to render_template('projects/show')
        end
      end
    end

    describe 'DELETE destroy' do
      context 'for a non-admin user' do
        it 'redirects to the projects_path' do
          project = FactoryGirl.create(:project)
          delete :destroy, id: project
          expect(assigns[:project]).not_to be_nil
          expect(response).to redirect_to(projects_path)
        end
      end
    end
  end
end
