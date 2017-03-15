require 'spec_helper'

describe CompetitionsController, :type => :controller do
  describe 'GET open' do
    it 'renders the page' do
      get :open
      expect(response).to be_success
      expect(assigns[:projects]).not_to be_nil
      expect(response).to render_template('competitions/open')
    end
  end
end