# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Public Section', :type => :feature do

  before do 
    FactoryGirl.create(:project) if Project.count < 1
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

  context 'for a person who has not logged in' do
    describe 'visiting the welcome page' do
      before do
        visit welcome_path
      end

      it 'shows the home page' do
        expect(page).to have_content(NucatsAssist::plain_app_name)
        expect(page).to have_content('Current and Recent Competitions')
        expect(page).to have_content('Login')
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

end
