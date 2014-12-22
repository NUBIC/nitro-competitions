# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Public Section', :type => :feature do

  context 'for a person who has not logged in' do

    describe 'visiting the welcome page' do
      before do
        visit welcome_path
      end

      it 'shows the home page' do
        expect(page).to have_content(NucatsAssist::plain_app_name)
        expect(page).to have_content('Current and Recent Competitions')
      end
    end
  end

end
