# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe RolesController, :type => :controller do

  context 'with a logged in user' do
    user_login

    describe 'GET index' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        it 'redirects to the sponsor_path' do
          get :index, :sponsor_id => program.id
          expect(response).to redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          get :index, :sponsor_id => program.id
          expect(assigns[:sponsor]).not_to be_nil
          expect(assigns[:roles]).to be_nil
        end
      end
    end

    describe 'GET show' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        let(:role) { FactoryGirl.create(:role) }
        it 'redirects to the sponsor_path' do
          get :show, :sponsor_id => program.id, :role_id => role.id
          expect(response).to redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          get :show, :sponsor_id => program.id, :role_id => role.id
          expect(assigns[:sponsor]).not_to be_nil
          expect(assigns[:role]).to be_nil
        end
      end
    end

    describe 'GET add' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        let(:role) { FactoryGirl.create(:role) }
        it 'redirects to the sponsor_path' do
          get :add, :sponsor_id => program.id, :role_id => role.id
          expect(response).to redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          get :add, :sponsor_id => program.id, :role_id => role.id
          expect(assigns[:sponsor]).not_to be_nil
          expect(assigns[:role]).not_to be_nil
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
          expect(response).to redirect_to(sponsor_role_path(program, role))
        end
        it 'assigns variables' do
          delete :remove, :id => roles_user.id, :sponsor_id => program.id, :role_id => role.id
          expect(assigns[:sponsor]).not_to be_nil
          expect(assigns[:roles_user]).not_to be_nil

          expect(assigns[:role]).to be_nil
          expect(assigns[:roles]).to be_nil
        end
      end
    end
  end
end
