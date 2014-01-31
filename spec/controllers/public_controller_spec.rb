# -*- coding: utf-8 -*-

require 'spec_helper'

describe PublicController do
  describe 'GET welcome' do
    it 'renders the page' do
      get :welcome
      response.should be_success
      assigns[:projects].should_not be_nil
      response.should render_template('public/welcome')
    end
  end

  describe 'GET disallowed' do
    it 'renders the page' do
      get :disallowed
      response.should be_success
      response.should render_template('public/disallowed')
    end
  end
end