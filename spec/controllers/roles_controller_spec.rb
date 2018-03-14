# -*- coding: utf-8 -*-

describe RolesController, :type => :controller do

  context 'with a logged in user' do
    user_login

    describe 'GET index' do
      context 'for a non admin' do
        let(:program) { FactoryGirl.create(:program) }
        it 'redirects to the sponsor_path' do
          process :index, method: :get, params: { sponsor_id: program }
          expect(response).to redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          process :index, method: :get, params: { sponsor_id: program }
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
          process :show, method: :get, params: { sponsor_id: program, role_id: role }
          expect(response).to redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          process :show, method: :get, params: { sponsor_id: program, role_id: role }
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
          process :add, method: :get, params: { sponsor_id: program, role_id: role }
          expect(response).to redirect_to(sponsor_path(program))
        end
        it 'assigns variables' do
          process :add, method: :get, params: { sponsor_id: program, role_id: role }
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
          process :remove, method: :delete, params: { id: roles_user, sponsor_id: program, role_id: role }
          expect(response).to redirect_to(sponsor_role_path(program, role))
        end
        it 'assigns variables' do
          process :remove, method: :delete, params: { id: roles_user, sponsor_id: program, role_id: role }
          expect(assigns[:sponsor]).not_to be_nil
          expect(assigns[:roles_user]).not_to be_nil

          expect(assigns[:role]).to be_nil
          expect(assigns[:roles]).to be_nil
        end
      end
    end
  end
end
