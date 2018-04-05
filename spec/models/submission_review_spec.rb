# -*- coding: utf-8 -*-

describe SubmissionReview, :type => :model do
  let(:project) { FactoryGirl.create(:project) }
  let(:unscored_review) { FactoryGirl.create(:submission_review, project: project, innovation_score: nil, scope_score: nil, team_score: nil, environment_score: nil, impact_score: nil, budget_score: nil, completion_score: nil, overall_score: 1, other_score: nil) }

  it { is_expected.to belong_to(:submission) }
  it { is_expected.to have_one(:applicant) }
  it { is_expected.to have_one(:project) }
  it { is_expected.to belong_to(:reviewer) }
  it { is_expected.to belong_to(:user) }

  WithScoring::CRITERIA.each do |criterion|
    it { should validate_numericality_of("#{criterion}_score".to_sym) }
  end

  it {should validate_numericality_of(:overall_score) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:submission_review)).to be_an_instance_of(SubmissionReview)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:submission_review)).to be_persisted
  end

  describe '.incomplete?' do
    let(:project) {FactoryGirl.create(:project, show_impact_score: false)}

    it 'returns false when all project criteria are scored' do
      submission_review  = FactoryGirl.create(:submission_review, project: project, innovation_score: 5, scope_score: 4, team_score: 1, environment_score: 1, impact_score: 0, budget_score: 0, completion_score: 0, other_score: 0)
      expect(submission_review.incomplete?).to be false
    end

    it 'returns true when not all project criteria are scored' do
      submission_review  = FactoryGirl.create(:submission_review, project: project, innovation_score: 5, scope_score: 4, team_score: 0, environment_score: 0, impact_score: 0, budget_score: 0, completion_score: 0, other_score: 0)
      expect(submission_review.incomplete?).to be true
    end
  end


  describe '.unscored?' do

    it 'returns true for an unscored review' do
      submission_review_nils  = FactoryGirl.create(:submission_review, project: project, innovation_score: nil, scope_score: nil, team_score: nil, environment_score: nil, impact_score: nil)
      expect(unscored_review.unscored?).to be true
      expect(submission_review_nils.unscored?).to be true
    end

    it 'returns false for a scored review' do
      submission_review_complete = FactoryGirl.create(:submission_review, project: project, innovation_score: 3, scope_score: 3, team_score: 3, environment_score: 3, impact_score: 3)
      submission_review_partial = FactoryGirl.create(:submission_review, project: project, innovation_score: nil, scope_score: 3, team_score: 3, environment_score: 3, impact_score: 3)
      expect(submission_review_complete.unscored?).to be false
      expect(submission_review_partial.unscored?).to be false
    end
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
      WithScoring::CRITERIA.map{ |criterion| "#{criterion}_score".to_sym } << :overall_score
    }

    describe 'for a new SubmissionReview' do
      it 'defaults scores to 0' do
        submission_review = SubmissionReview.new
        submission_review.project = project
        submission_review.save!
        scores.each do |s|
          score = submission_review.send(s)
          expect(score).not_to be_blank
          expect(score).to eq 0
        end
        expect(submission_review.review_score).to be_blank
        expect(submission_review.composite_score).to eq 0
        expect(submission_review.incomplete?).to be true
      end
    end

    describe 'for an existing SubmissionReview' do
      it 'has non-zero values' do
        submission_review = FactoryGirl.create(:submission_review, project: project)
        scores.each do |s|
          score = submission_review.send(s)
          expect(score).not_to be_blank
          expect(score).to be > 0
        end
        expect(submission_review.review_score).not_to be_blank
        expect(submission_review.composite_score).to be > 0
        expect(submission_review.incomplete?).to be false
      end
    end
  end

  context 'composite scoring' do
    project = FactoryGirl.create(:project, show_impact_score: false)
    submission_review  = FactoryGirl.create(:submission_review, project: project, innovation_score: 5, scope_score: 4, team_score: 1, environment_score: 1, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 1, other_score: 0)
    submission_review2 = FactoryGirl.create(:submission_review, project: project, innovation_score: 9, scope_score: 3, team_score: 5, environment_score: 2, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 1, other_score: 3)
    submission_review3 = FactoryGirl.create(:submission_review, project: project, innovation_score: 7, scope_score: 7, team_score: 7, environment_score: 7, impact_score: 1, budget_score: 1, completion_score: 1, overall_score: 1, other_score: 1)
    submission_review4 = FactoryGirl.create(:submission_review, project: project, innovation_score: 0, scope_score: 7, team_score: 8, environment_score: 8, impact_score: nil, budget_score: nil, completion_score: 1, overall_score: 1, other_score: 1)

    it 'calculates a review composite score based on project criteria' do
      expect(submission_review.composite_score).to  eq 11.fdiv(4).round(2)
      expect(submission_review2.composite_score).to eq 19.fdiv(4).round(2)
      expect(submission_review3.composite_score).to eq 28.fdiv(4).round(2)
      expect(submission_review4.composite_score).to eq 23.fdiv(3).round(2)
      expect(unscored_review.composite_score).to be 0
    end

  end

end
