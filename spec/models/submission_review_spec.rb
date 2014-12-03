# -*- coding: utf-8 -*-
require 'spec_helper'

describe SubmissionReview do

  it { should belong_to(:submission) }
  it { should have_one(:applicant) }
  it { should have_one(:project) }
  it { should belong_to(:reviewer) }
  it { should belong_to(:user) }

  it 'can be instantiated' do
    FactoryGirl.build(:submission_review).should be_an_instance_of(SubmissionReview)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:submission_review).should be_persisted
  end

  describe '.this_project' do
    let(:submission_review) { FactoryGirl.create(:submission_review) }
    let(:project) { submission_review.project }
    it 'returns SubmissionReviews for the given project' do
      submission_reviews = SubmissionReview.this_project(project.id)
      submission_reviews.should_not be_blank
      submission_reviews.each do |sr|
        sr.submission.should_not be_blank
        sr.submission.project.should_not be_blank
        sr.submission.project.should eq project
      end
    end
  end

  describe '.active' do
    let(:submission_review) { FactoryGirl.create(:submission_review) }
    let!(:project) { submission_review.project }
    it 'returns SubmissionReviews for the given projects' do
      projects = Project.all
      submission_reviews = SubmissionReview.active(projects)
      submission_reviews.each do |sr|
        sr.submission.should_not be_blank
        sr.submission.project.should_not be_blank
        projects.should include(sr.submission.project)
      end
    end
  end

  context 'scoring' do
    let(:scores) {
      [
        :innovation_score,
        :impact_score,
        :scope_score,
        :team_score,
        :environment_score,
        :other_score,
        :budget_score,
        :overall_score
      ]
    }
    describe 'for a new SubmissionReview' do
      it 'defaults scores to 0' do
        submission_review = SubmissionReview.new
        scores.each do |s|
          score = submission_review.send(s)
          score.should_not be_blank
          score.should eq 0
        end
        submission_review.review_score.should be_blank
        submission_review.composite_score.should eq 0
        submission_review.has_zero?.should be_truthy
        submission_review.count_nonzeros?.should eq 0
      end
    end
    describe 'for an existing SubmissionReview' do
      it 'has non-zero values' do
        submission_review = FactoryGirl.create(:submission_review)
        scores.each do |s|
          score = submission_review.send(s)
          score.should_not be_blank
          score.should be > 0
        end
        submission_review.review_score.should_not be_blank
        submission_review.composite_score.should be > 0
        submission_review.has_zero?.should be_falsey
        submission_review.count_nonzeros?.should be > 5
      end
    end
  end

end
