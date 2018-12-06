# -*- coding: utf-8 -*-

describe ProjectsController, :type => :controller do


  context 'for a non-admin user' do
    # hir = FactoryBot.create(:ldap_user, username: 'mjb0760', first_name: 'Matthew', last_name: 'Baumann', email: 'matthew.baumann@northwestern.edu')
    hir = FactoryBot.create(:mjb_user)

    allow(hir).to receive(:get_ldap_entry)
      .with(hir.username)
      .and_return(
        [LdapResult.new([hir.username], [hir.first_name], [hir.last_name], [hir.email])]
      )


    puts "#{hir.inspect}"
    # login(her)
    # login_as(hir, scope: :ldap_user)

    # describe 'GET new' do
    #   it 'redirects to projects_path' do
    #     process :new, method: :get
    #     expect(response).to redirect_to(projects_path)
    #   end
    # end
  end

  context 'with a logged in user' do
    user_login

    describe 'GET index' do
      it 'renders the page' do
        process :index, method: :get
        expect(response).to be_successful
      end
      it 'assigns variables' do
        process :index, method: :get
        expect(assigns[:projects]).not_to be_nil
      end
    end

    context 'with a logged in user' do
      user_login

      describe 'GET show' do
        it 'renders the page' do
          project = FactoryBot.create(:project)
          process :index, method: :get, params: { id: project }
          expect(response).to be_successful
        end
      end
    end

    describe 'GET edit' do
      context 'for a non-admin user' do
        it 'redirects to the project_path' do
          project = FactoryBot.create(:project)
          process :edit, method: :get, params: { id: project }
          expect(response).to redirect_to(project_path(project))
        end
      end
    end

    describe 'PUT update' do
      context 'for a non-admin user' do
        it 'renders the show template' do
          project = FactoryBot.create(:project)
          process :update, method: :put, params: { id: project }
          expect(response).to render_template('projects/show')
        end
      end
    end

    describe 'POST create' do
      it 'assigns variables' do
        program = FactoryBot.create(:program)
        params = { project_title: 'the title of the project', project_name: 'project_name_xxx',
                   initiation_date: Date.today, submission_open_date: Date.today, submission_close_date: Date.today,
                   review_start_date: Date.today, review_end_date: Date.today, project_period_start_date: Date.today, project_period_end_date: Date.today }

        process :create, method: :post, params: { project: params, program_id: program }
        expect(assigns[:project]).not_to be_nil
      end
      it 'redirects to project_path'
    end

    describe 'DELETE destroy' do
      context 'for a non-admin user' do
        it 'redirects to the projects_path' do
          project = FactoryBot.create(:project)
          process :destroy, method: :delete, params: { id: project }
          expect(assigns[:project]).not_to be_nil
          expect(response).to redirect_to(projects_path)
        end
      end
    end
  end
end
