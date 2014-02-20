# -*- coding: utf-8 -*-

require 'spec_helper'

describe AdminsController do

  context 'with a logged in admin user' do
    before do
      login(admin_login)
    end

    describe 'GET index' do
      let(:project) { FactoryGirl.create(:project) }
      it 'assigns @sponsor' do
        get :index, :project_id => project.id
        assigns[:sponsor].should_not be_nil
      end
      it 'does not assign @submissions' do
        get :index, :project_id => project.id
        assigns[:submissions].should be_nil
      end
      it 'redirects to projects_path' do
        get :index, :project_id => project.id
        response.should redirect_to(projects_path)
      end
    end

    describe 'GET view_activities' do
      let(:project) { FactoryGirl.create(:project) }
      it 'redirects to projects_path' do
        get :view_activities, :project_id => project.id
        response.should redirect_to(projects_path)
      end
    end

    describe 'GET submissions' do
      let(:project) { FactoryGirl.create(:project) }
      it 'redirects to projects_path' do
        get :submissions, :project_id => project.id
        response.should redirect_to(projects_path)
      end
    end

    describe 'PUT reviews' do
      let(:project) { FactoryGirl.create(:project) }
      it 'redirects to projects_path' do
        put :reviews, :project_id => project.id
        response.should redirect_to(projects_path)
      end
    end
  end
end