# -*- coding: utf-8 -*-

require 'spec_helper'

describe ApplicantsController, :type => :controller do

  context "with an authenticated user" do
    before(:each) do
      login(user_login)
    end

    describe 'GET index' do
      # cf. has_read_all?
      describe 'without having read all' do
        let(:project) { FactoryGirl.create(:project) }
        it 'assigns @project' do
          get :index, :project_id => project.id
          expect(assigns[:project]).to eq project
        end
        it 'assigns @sponsor' do
          get :index, :project_id => project.id
          expect(assigns[:sponsor]).to eq project.program
        end
        it 'redirects to projects_path' do
          get :index, :project_id => project.id
          expect(response).to redirect_to(projects_path)
        end
      end
    end

    describe 'GET new' do
      let(:project) { FactoryGirl.create(:project) }
      # FIXME: Spec fails with the following
      #        NoMethodError:
      #          undefined method `user' for nil:NilClass
      #        # ./app/controllers/applicants_controller.rb:42:in `new'
      # it 'redirects to applicants path' do
      #   get :new, :project_id => project.id
      #   response.should redirect_to(applicants_path)
      # end

      it 'renders the new template' do
        allow(controller).to receive(:handle_ldap).and_return(true)
        get :new, :project_id => project.id, :username => 'spuds'
        expect(response).to be_success
        expect(response).to render_template('applicants/new')
      end
    end

    describe 'GET show' do
      context 'for a logged in user who is not an admin for the sponsor' do
        let(:project) { FactoryGirl.create(:project) }
        let(:user) { FactoryGirl.create(:user) }
        it 'redirects to the project_path' do
          get :show, :id => user, :project_id => project.id
          expect(response).to redirect_to(project_path(project))
        end
      end
    end

    describe 'GET edit' do
      context 'for a logged in user who is not an admin for the sponsor' do
        let(:project) { FactoryGirl.create(:project) }
        let(:user) { FactoryGirl.create(:user) }
        it 'redirects to the project_path' do
          get :edit, :id => user, :project_id => project.id
          expect(response).to redirect_to(project_path(project))
        end
      end
    end

  end

  # test "should create applicant" do
  #   assert_difference('User.count') do
  #     post :create, {'project_id' => "1", :applicant => {:username=>"spuds", :first_name=>"idaho", :last_name=>"idaho", :email=>"idaho@spuds.com" }}
  #   end
  #   assert_not_nil assigns(:project)
  #   assert_response :redirect
  #   #assert_redirected_to applicant_path(assigns(:applicant))
  # end

  # test "should update applicant" do
  #   put :update, :id => "3", :project_id => projects(:three).to_param, :applicant => { }
  #   assert_not_nil assigns(:applicant )
  #   assert_redirected_to new_project_applicant_submission_path(projects(:three).to_param, 3)
  # end

  # test "should destroy applicant" do
  #   assert_difference('User.count', 0) do
  #     delete :destroy, :id => "3", :project_id => "1"
  #   end
  #   assert_not_nil assigns(:applicant )
  # end

  # test "should destroy applicant2" do
  #   assert_difference('User.count', 0) do
  #     delete :destroy, :id => "3"
  #   end
  #   assert_not_nil assigns(:applicant )
  #   assert_redirected_to applicants_path
  # end
end