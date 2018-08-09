# -*- coding: utf-8 -*-

describe 'Public Section', :type => :feature do

  before :each do
    @pre_initiated_project  = FactoryBot.create(:pre_initiated_project)
    @initiated_project  = FactoryBot.create(:initiated_project)
    @open_project  = FactoryBot.create(:open_project)
    @closed_project  = FactoryBot.create(:closed_project)
  end

  context 'for a person who has not logged in' do
    describe 'visiting the welcome page' do
      before do
        visit welcome_path
      end

      it 'shows the navigation bar on the welcome page' do
        expect(page).to have_content(NucatsAssist::plain_app_name)
        expect(page).to have_content('Login')
      end

      it 'shows initiated competition on the welcome page' do
        expect(page).to have_content 'New Announcement'
        expect(page).to have_content 'Initiated Project'
      end

      it 'shows open competition on the welcome page' do
        expect(page).to have_content 'Apply'
        expect(page).to have_content 'Open Project'
      end

      it 'does not show pre-initiation competition on the welcome page' do
        expect(page).to_not have_content 'Pre-announcement'
        expect(page).to_not have_content 'Pre-Initiated Project'
      end

      it 'does not show closed competition on the welcome page' do
        expect(page).to_not have_content 'Under Review'
        expect(page).to_not have_content 'Closed Project'
      end

    end

    describe 'visiting the login page' do
      before do
        visit new_user_session_path
      end

      it 'shows the login messages' do
        expect(page).to have_content('Click on icon above to select domain')
        expect(page).to have_content('Please log in below')
      end
    end
  end

  context 'for a person who has logged in' do
    describe 'visiting the projects page' do
      before do
        login
        visit '/projects'
      end

      it 'shows the home page' do
        # print page.html
        expect(page).to have_content(NucatsAssist::plain_app_name)
        expect(page).to have_content('Current and Recent Competitions')
        expect(page).to have_content('FName LName') # cf. spec/factories/user.rb
      end
    end
  end

end
