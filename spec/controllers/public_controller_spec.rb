# -*- coding: utf-8 -*-

describe PublicController, :type => :controller do
  describe 'GET welcome' do
    it 'renders the page' do
      process :welcome, method: :get
      expect(response).to be_successful
      expect(assigns[:projects]).not_to be_nil
      expect(response).to render_template('welcome')
    end
  end

  describe 'GET disallowed' do
    it 'renders the page' do
      process :disallowed, method: :get
      expect(response).to be_successful
      expect(response).to render_template('disallowed')
    end
  end
end
