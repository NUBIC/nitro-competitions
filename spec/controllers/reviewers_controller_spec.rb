# -*- coding: utf-8 -*-
require 'spec_helper'

describe ReviewersController do

  describe 'GET index' do
    it 'renders the page' do
      get :index
      response.should be_success
      assigns[:assigned_submission_reviews].should eq []
    end
  end

  describe 'GET edit' do
    let(:review) { FactoryGirl.create(:submission_review) }
    it 'redirects to projects_path' do
      get :edit, :id => review.id, :project_id => review.project.id
      response.should redirect_to(project_path(review.project))
    end
  end

  # test "should update reviewer" do
  #   put :update, :id => reviewers(:one).to_param, :reviewer => { }
  #   assert_redirected_to project_reviewers_url(projects(:one))
  # end

  # test "should destroy reviewer" do
  #   # won't work as must be admin
  #   assert_difference('Reviewer.count', 0) do
  #     delete :destroy, :id => reviewers(:one).to_param
  #   end

  #   assert_redirected_to project_reviewers_path(projects(:one))
  # end

end