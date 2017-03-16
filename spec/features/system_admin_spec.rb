# -*- coding: utf-8 -*-

describe 'View for a System Admin', type: :feature do
  context 'With an open competition', js: true do
    context 'with a logged in system admin' do 
      before(:each) do 
        program = FactoryGirl.create(:program)
        project = FactoryGirl.create(:project, project_title: 'Voucher Program', 
                        program: program,
                        submission_close_date: 1.week.from_now, 
                        submission_open_date: 1.day.ago,
                        initiation_date: 1.day.ago, 
                        visible: true)
        user = FactoryGirl.create(:user, system_admin: true)

        login_as(user)
        visit '/projects'
      end

      describe 'visiting the /projects page' do

        it 'shows the the admin menu items' do
          expect(page).to have_content('Admin')

        end

          # it 'should allow system_admin to access act as user' do 
          #   click_on 'Admin'
          #   expect(page).to have_content('Act as user')
          #   # click_on 'Act as user'
          #   expect(current_path).to eq("/projects/#{project.id}/admins/act_as_user")

          #   expect(page).to have_content 'Select a user to act as. Note that you will have to logout and login back in to get back to your own account. '
          # end
      end
    end
  end
end
