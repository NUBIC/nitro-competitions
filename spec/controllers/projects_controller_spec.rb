# -*- coding: utf-8 -*-

describe ProjectsController, :type => :controller do

  
  context 'for a non-admin user' do
    login(FactoryGirl.create(:user, username: 'uname'))

    describe 'GET new' do
      it 'redirects to projects_path' do
        get :new
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  context 'with a logged in user' do
    user_login

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

    context 'with a logged in user' do
      user_login

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

    describe 'POST create' do
      it 'assigns variables' do
        program = FactoryGirl.create(:program)
        params = { project_title: 'the title of the project', project_name: 'project_name_xxx', 
                   initiation_date: Date.today, submission_open_date: Date.today, submission_close_date: Date.today,
                   review_start_date: Date.today, review_end_date: Date.today, project_period_start_date: Date.today, project_period_end_date: Date.today }

        post :create, program_id: program.id, project: params
        expect(assigns[:project]).not_to be_nil
      end
      it 'redirects to project_path'
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
