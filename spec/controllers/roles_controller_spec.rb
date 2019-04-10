# -*- coding: utf-8 -*-

describe RolesController, :type => :controller do
  include Rails.application.routes.url_helpers

  context 'with a logged in non-admin user' do
    @user = FactoryBot.create(:user)

    login_as(@user)

    describe 'GET index' do
      let(:program) { FactoryBot.create(:program) }
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

    describe 'GET show' do
      let(:program) { FactoryBot.create(:program) }
      let(:role) { FactoryBot.create(:role) }
      it 'redirects to the sponsor_path' do
        process :show, method: :get, params: { sponsor_id: program, id: role }
        expect(response).to redirect_to(sponsor_path(program))
      end
      it 'assigns variables' do
        process :show, method: :get, params: { sponsor_id: program, id: role }
        expect(assigns[:sponsor]).not_to be_nil
        expect(assigns[:role]).to be_nil
      end
    end

    describe 'GET add' do
      let(:program) { FactoryBot.create(:program) }
      let(:user) { FactoryBot.create(:user) }
      let(:role) { FactoryBot.create(:role) }
      it 'redirects to the sponsor_path' do
        process :add, method: :get, params: { sponsor_id: program, id: role, user_id: user }
        expect(response).to redirect_to(sponsor_path(program))
      end
      it 'assigns variables' do
        process :add, method: :get, params: { sponsor_id: program, id: role, user_id: user }
        expect(assigns[:sponsor]).not_to be_nil
        expect(assigns[:role]).not_to be_nil
      end
    end

    describe 'GET remove' do
      let(:roles_user) { FactoryBot.create(:roles_user) }
      it 'redirects to the sponsor_path' do
        process :remove, method: :get, params: { sponsor_id: roles_user.program, user_id: roles_user.user, id: roles_user }
        expect(response).to redirect_to(sponsor_path(roles_user.program))
      end
      it 'assigns variables' do
        process :remove, method: :get, params: { sponsor_id: roles_user.program, user_id: roles_user.user, id: roles_user }
        expect(assigns[:sponsor]).not_to be_nil
        expect(assigns[:roles_user]).not_to be_nil

        expect(assigns[:role]).to be_nil
        expect(assigns[:roles]).to be_nil
      end
    end
  end
end
