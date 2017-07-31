# -*- coding: utf-8 -*-

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
