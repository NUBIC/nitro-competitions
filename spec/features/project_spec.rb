# -*- coding: utf-8 -*-

describe 'View for a System Admin', type: :feature do
  context 'With an open competition', js: true do
    before(:each) do
      @program  = FactoryBot.create(:program)
      @project  = FactoryBot.create(:project, project_title: 'Voucher Program',
                                              program: @program,
                                              submission_close_date: 1.week.from_now,
                                              submission_open_date: 1.day.ago,
                                              initiation_date: 1.day.ago,
                                              visible: true)
      @user     = FactoryBot.create(:user)
      @admin    = FactoryBot.create(:user, system_admin: true)
    end

    context 'when user is not logged in as sponsor or system admin' do
      before(:each) do
        login_as(@user)
      end

      describe 'visiting a project' do
        it 'does not show the project duplication link' do
          visit "/projects/#{@project.id}"
          expect(page).not_to have_link('Use this competition as a template')
        end
      end
    end

    context 'when user is logged in as sponsor admin' do
      before(:each) do
        @role = FactoryBot.create(:role, name: 'Admin')
        FactoryBot.create(:roles_user, program: @program, role: @role, user: @user)
        login_as(@user)
      end

      describe 'visiting a project page' do
        it 'shows the project duplication link' do
          expect(@program.admins).to eq([@user])
          visit "/projects/#{@project.id}"
          expect(page).to have_link('Use this competition as a template')
        end
      end

      describe 'duplicating a project page' do
        before(:each) do
          visit "/projects/#{@project.id}"
          click_on('Use this competition as a template')
        end

        it 'displays date and title errors' do
          skip
        end

        it 'pre-populates a duplicated project with date and visibility attributes updated' do
          expect(current_path).to eq("/projects/#{@project.id}/copy")
          expect(page).to have_field('project[visible]', checked: false)
          expect(page).to have_field('project[project_title]', with: "#{@project.project_title}")
          click_on("Dates")
          expect(page).to have_field('project[submission_open_date]', with: '')
          expect(page).to have_field('project[submission_close_date]', with: '')
          expect(page).to have_field('project[initiation_date]', with: '')
        end
      end
    end
  end
end
