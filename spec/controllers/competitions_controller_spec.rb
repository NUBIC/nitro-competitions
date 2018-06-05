describe CompetitionsController, :type => :controller do
  describe 'GET open' do
    it 'renders the page' do
      process :open, method: :get #, params: { project_id: project }
      get :open
      expect(response).to be_success
      expect(assigns[:projects]).not_to be_nil
      expect(response).to render_template('competitions/open')
    end
  end
end