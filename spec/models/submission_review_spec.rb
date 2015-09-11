# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: submission_reviews
#
#  id                              :integer          not null, primary key
#  submission_id                   :integer
#  reviewer_id                     :integer
#  review_score                    :float
#  review_text                     :text
#  review_doc                      :binary
#  review_status                   :string(255)
#  review_completed_at             :datetime
#  innovation_score                :integer          default(0)
#  impact_score                    :integer          default(0)
#  scope_score                     :integer          default(0)
#  team_score                      :integer          default(0)
#  environment_score               :integer          default(0)
#  budget_score                    :integer          default(0)
#  completion_score                :integer          default(0)
#  assigned_at                     :datetime
#  accepted_at                     :datetime
#  assignment_notification_cnt     :integer          default(0)
#  assignment_notification_sent_at :datetime
#  thank_you_sent_at               :datetime
#  assignment_notification_id      :integer
#  thank_you_sent_id               :integer
#  innovation_text                 :text
#  impact_text                     :text
#  scope_text                      :text
#  team_text                       :text
#  environment_text                :text
#  budget_text                     :text
#  overall_score                   :integer          default(0)
#  overall_text                    :text
#  other_score                     :integer          default(0)
#  other_text                      :text
#  created_id                      :integer
#  created_ip                      :string(255)
#  updated_id                      :integer
#  updated_ip                      :string(255)
#  deleted_at                      :datetime
#  deleted_id                      :integer
#  deleted_ip                      :string(255)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

require 'spec_helper'

describe SubmissionReview, :type => :model do

  it { is_expected.to belong_to(:submission) }
  it { is_expected.to have_one(:applicant) }
  it { is_expected.to have_one(:project) }
  it { is_expected.to belong_to(:reviewer) }
  it { is_expected.to belong_to(:user) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:submission_review)).to be_an_instance_of(SubmissionReview)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:submission_review)).to be_persisted
  end

  describe '.this_project' do
    let(:submission_review) { FactoryGirl.create(:submission_review) }
    let(:project) { submission_review.project }
    it 'returns SubmissionReviews for the given project' do
      submission_reviews = SubmissionReview.this_project(project.id)
      expect(submission_reviews).not_to be_blank
      submission_reviews.each do |sr|
        expect(sr.submission).not_to be_blank
        expect(sr.submission.project).not_to be_blank
        expect(sr.submission.project).to eq project
      end
    end
  end

  describe '.active' do
    let(:submission_review) { FactoryGirl.create(:submission_review) }
    let!(:project) { submission_review.project }
    it 'returns SubmissionReviews for the given projects' do
      projects = Project.all
      submission_reviews = SubmissionReview.active(projects.map{|pr| pr.id})
      submission_reviews.each do |sr|
        expect(sr.submission).not_to be_blank
        expect(sr.submission.project).not_to be_blank
        expect(projects).to include(sr.submission.project)
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
          expect(score).not_to be_blank
          expect(score).to eq 0
        end
        expect(submission_review.review_score).to be_blank
        expect(submission_review.composite_score).to eq 0
        expect(submission_review.has_zero?).to be_truthy
        expect(submission_review.count_nonzeros?).to eq 0
      end
    end
    describe 'for an existing SubmissionReview' do
      it 'has non-zero values' do
        submission_review = FactoryGirl.create(:submission_review)
        scores.each do |s|
          score = submission_review.send(s)
          expect(score).not_to be_blank
          expect(score).to be > 0
        end
        expect(submission_review.review_score).not_to be_blank
        expect(submission_review.composite_score).to be > 0
        expect(submission_review.has_zero?).to be_falsey
        expect(submission_review.count_nonzeros?).to be > 5
      end
    end
  end

end
