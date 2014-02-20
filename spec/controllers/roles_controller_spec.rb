# -*- coding: utf-8 -*-
require 'spec_helper'

describe RolesController do

  context 'with a logged in user' do
    before do
      login(user_login)
    end

    describe 'GET index' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        it 'redirects to the sponsor_path' do
          get :index, :sponsor_id => program.id
          response.should redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          get :index, :sponsor_id => program.id
          assigns[:sponsor].should_not be_nil
          assigns[:roles].should be_nil
        end
      end
    end

    describe 'GET show' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        let(:role) { FactoryGirl.create(:role) }
        it 'redirects to the sponsor_path' do
          get :show, :sponsor_id => program.id, :role_id => role.id
          response.should redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          get :show, :sponsor_id => program.id, :role_id => role.id
          assigns[:sponsor].should_not be_nil
          assigns[:role].should be_nil
        end
      end
    end

    describe 'GET add' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        let(:role) { FactoryGirl.create(:role) }
        it 'redirects to the sponsor_path' do
          get :add, :sponsor_id => program.id, :role_id => role.id
          response.should redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          get :add, :sponsor_id => program.id, :role_id => role.id
          assigns[:sponsor].should_not be_nil
          assigns[:role].should_not be_nil
        end
      end
    end

    describe 'DELETE remove' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        let(:roles_user) { FactoryGirl.create(:roles_user) }
        let(:role) { roles_user.role }
        it 'redirects to the sponsor_role_path' do
          delete :remove, :id => roles_user.id, :sponsor_id => program.id, :role_id => role.id
          response.should redirect_to(sponsor_role_path(program, role))
        end
        it 'assigns variables' do
          delete :remove, :id => roles_user.id, :sponsor_id => program.id, :role_id => role.id
          assigns[:sponsor].should_not be_nil
          assigns[:roles_user].should_not be_nil

          assigns[:role].should be_nil
          assigns[:roles].should be_nil
        end
      end
    end
  end
end