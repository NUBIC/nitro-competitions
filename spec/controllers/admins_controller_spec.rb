# -*- coding: utf-8 -*-

describe AdminsController, :type => :controller do

  context 'with a logged in admin user' do
    admin_login

    describe 'GET index' do
      let(:project) { FactoryGirl.create(:project) }
      it 'assigns @sponsor' do
        process :index, method: :get, params: { project_id: project }
        expect(assigns[:sponsor]).not_to be_nil
      end
      it 'does not assign @submissions' do
        process :index, method: :get, params: { project_id: project }
        expect(assigns[:submissions]).to be_nil
      end
      it 'redirects to projects_path' do
        process :index, method: :get, params: { project_id: project }
        expect(response).to redirect_to(projects_path)
      end
    end

    describe 'GET view_activities' do
      let(:project) { FactoryGirl.create(:project) }
      it 'redirects to projects_path' do
        process :view_activities, method: :get, params: { project_id: project }
        expect(response).to redirect_to(projects_path)
      end
    end

    describe 'GET submissions' do
      let(:project) { FactoryGirl.create(:project) }
      it 'redirects to projects_path' do
        process :submissions, method: :get, params: { project_id: project }
        expect(response).to redirect_to(projects_path)
      end
    end

    describe 'PUT reviews' do
      let(:project) { FactoryGirl.create(:project) }
      it 'redirects to projects_path' do
        process :reviews, method: :put, params: { project_id: project }
        expect(response).to redirect_to(projects_path)
      end
    end
  end


  # TODO: This was brought in from the reviewers_controller_spec. When and where the 
  # reviewer gets destroyed and how that is tested should be reviewed. 

  # describe 'DELETE destroy' do
  #   it 'redirects to project_reviewers_path' do
  #     delete :destroy, :id => review
  #     response.should redirect_to(project_reviewers_path(review.submission.project.program))
  #   end
  # end



end