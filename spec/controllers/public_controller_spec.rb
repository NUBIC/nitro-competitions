# -*- coding: utf-8 -*-

require 'spec_helper'

describe PublicController, :type => :controller do
  describe 'GET welcome' do
    it 'renders the page' do
      get :welcome
      expect(response).to be_success
      expect(assigns[:projects]).not_to be_nil
      expect(response).to render_template('public/welcome')
    end
  end

  describe 'GET disallowed' do
    it 'renders the page' do
      get :disallowed
      expect(response).to be_success
      expect(response).to render_template('public/disallowed')
    end
  end
end