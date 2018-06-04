# -*- coding: utf-8 -*-

describe ReviewersController, :type => :controller do

  context 'with a logged in user' do
    user_login

    describe 'GET index' do
      it 'renders the page' do
        process :index, method: :get
        expect(response).to be_success
        expect(assigns[:assigned_submission_reviews]).to eq []
      end
    end

    describe 'GET edit' do
      let(:review) { FactoryBot.create(:submission_review) }
      it 'redirects to projects_path' do
        process :edit, method: :get, params: { id: review, project_id: review.project }
        expect(response).to redirect_to(project_path(review.project))
      end
    end

    # This should potentially be moved over to the admins_controller_spec.
    describe 'PUT update' do
      let(:review) { FactoryBot.create(:submission_review) }
      it 'redirects to project_reviewers_path' do
        process :update, method: :put, params: { id: review, reviewer: {} }
        response.should redirect_to(project_reviewers_path(review.submission.project))
      end
    end
  end
end
