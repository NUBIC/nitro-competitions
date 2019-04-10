# -*- coding: utf-8 -*-

describe Submission, :type => :model do

  let(:submission) { FactoryBot.create(:submission) }

  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:applicant) }
  it { is_expected.to belong_to(:submitter) }
  it { is_expected.to belong_to(:effort_approver) }
  it { is_expected.to belong_to(:core_manager) }
  it { is_expected.to belong_to(:department_administrator) }
  it { is_expected.to belong_to(:applicant_biosketch_document) }
  it { is_expected.to belong_to(:application_document) }
  it { is_expected.to belong_to(:budget_document) }
  it { is_expected.to belong_to(:other_support_document) }
  it { is_expected.to belong_to(:document1) }
  it { is_expected.to belong_to(:document2) }
  it { is_expected.to belong_to(:document3) }
  it { is_expected.to belong_to(:document4) }

  it { is_expected.to have_many(:submission_reviews).dependent(:destroy) }
  it { is_expected.to have_many(:reviewers).through(:submission_reviews) }
  it { is_expected.to have_many(:key_personnel) }
  it { is_expected.to have_many(:key_people).through(:key_personnel) }

  describe 'validation of length on varchars for submission' do
    let(:submission) { FactoryBot.create(:submission) }
    it "validates length of varchars" do
      varchar_attributes = [:submission_status,
                            :irb_study_num,
                            :nucats_cru_contact_name,
                            :iacuc_study_num,
                            :effort_approver_username,
                            :department_administrator_username,
                            :submission_category,
                            :core_manager_username,
                            :notification_sent_to,
                            :type_of_equipment]
      varchar_attributes.each do |att|
        expect(submission).to validate_length_of(att)
      end
    end
  end

  it 'can be instantiated' do
    expect(FactoryBot.build(:submission)).to be_an_instance_of(Submission)
  end

  it 'can be saved successfully' do
    expect(FactoryBot.create(:submission)).to be_persisted
  end

  context 'validating' do
    describe 'submission_title' do
      it 'validates it is greater than 6 characters' do
        title = 'x' * 5
        submission = FactoryBot.build(:submission, :submission_title => title)
        expect(submission).not_to be_valid
        expect(submission.errors[:submission_title]).not_to be_blank
      end
      it 'validates it is less than 200 characters' do
        title = 'x' * 201
        submission = FactoryBot.build(:submission, :submission_title => title)
        expect(submission).not_to be_valid
        expect(submission.errors[:submission_title]).not_to be_blank
      end
    end
    describe 'direct_project_cost' do
      it 'validates it is within limits' do
        submission = FactoryBot.build(:submission, :direct_project_cost => 10)
        expect(submission).not_to be_valid
        expect(submission.errors[:direct_project_cost]).not_to be_blank
      end
    end
    describe 'submission_status' do
      it 'validates inclusion in Submission::STATUSES' do
        Submission::STATUSES.each do |s|
          submission = FactoryBot.build(:submission, :submission_status => "#{s}xxx")
          expect(submission).not_to be_valid
          submission.submission_status = s
          expect(submission).to be_valid
        end
      end
    end
  end

  describe '.recent' do
    it 'returns those submissions created within the last 3 weeks' do
      recent_project = FactoryBot.create(:project, :project_name => 'recent')
      older_project = FactoryBot.create(:project, :project_name => 'older')
      recent_submission = FactoryBot.create(:submission, :created_at => 2.weeks.ago, :project => recent_project)
      older_submission  = FactoryBot.create(:submission, :created_at => 20.weeks.ago, :project => older_project)

      submissions = Submission.recent
      expect(submissions).not_to be_blank
      expect(submissions).to include(recent_submission)
      expect(submissions).not_to include(older_submission)
    end
  end

  context 'scope' do

    describe '.associated' do
      it 'returns the submissions associated with a given project and applicant' do
        project     = FactoryBot.create(:project)
        applicant   = FactoryBot.create(:user)
        submission  = FactoryBot.create(:submission, project: project, applicant: applicant)

        expect(Submission.associated(project.id, applicant.id)).to include(submission)

        other_project = FactoryBot.create(:project)
        expect(Submission.associated(other_project.id, applicant.id)).not_to include(submission)
      end
    end

    describe '.associated_with_user' do
      it 'returns the submissions associated with a given applicant' do
        project     = FactoryBot.create(:project)
        applicant   = FactoryBot.create(:user)
        submission  = FactoryBot.create(:submission, project: project, applicant: applicant)

        expect(Submission.associated_with_user(applicant.id)).to include(submission)
      end
    end

  end

  context 'statuses' do
    it 'knows if it is complete' do
      sub = FactoryBot.create(:submission)
      expect(sub).to be_complete
    end
    it 'knows when effort_approver_username is required' do
      project_with_effort_approver    = FactoryBot.create(:project, :show_effort_approver => true, :require_effort_approver => true)
      project_without_effort_approver   = FactoryBot.create(:project, :show_effort_approver => true)
      submission  = FactoryBot.create(:submission, :project => project_with_effort_approver, :effort_approver_username => '')
      submission2 = FactoryBot.create(:submission, :project => project_without_effort_approver, :effort_approver_username => '')
      expect(submission.status).to eq('Incomplete')
      expect(submission2.status).to eq('Complete')
      submission.effort_approver_username = 'abc123'
      expect(submission.status).to eq("Complete")
    end
  end

  context 'cost' do
    let (:project) { FactoryBot.create(:project, min_budget_request: nil, max_budget_request: nil) }
    let (:sub) { FactoryBot.build(:submission, project: project) }
    describe '.max_project_cost' do
      it 'defaults to 50,000' do
        expect(sub.max_budget_request).to be_nil
        expect(sub.max_project_cost).to eq(50_000)
      end

      it 'returns the max_budget_request' do
        [15_000, 25_000, 35_000].each do |cost|
          sub.max_budget_request = cost
          expect(sub.max_project_cost).to eq(sub.max_budget_request)
        end
      end
    end

    describe '.min_project_cost' do
      it 'defaults to 1,000'  do
        expect(sub.min_budget_request).to be_nil
        expect(sub.min_project_cost).to eq(1000)
      end

      it 'returns the min_budget_request' do
        [500, 2000, 3000].each do |cost|
          sub.min_budget_request = cost
          expect(sub.min_project_cost).to eq(sub.min_budget_request)
        end
      end
    end
  end

  context 'scoring' do

    it 'returns 0s when there are no reviews' do
      expect(submission.unreviewed?).to be true
      expect(submission.composite_score).to eq 0
      expect(submission.overall_score_average).to eq 0
    end

    it 'calculates when there are scored reviews' do
      project    = FactoryBot.create(:project, show_innovation_score: false)
      submission_review  = FactoryBot.create(:submission_review, submission: submission, innovation_score: nil, scope_score: 4, team_score: 1, environment_score: 1, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 3, other_score: 0)
      submission_review2 = FactoryBot.create(:submission_review, submission: submission, innovation_score: nil, scope_score: 4, team_score: 5, environment_score: 2, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 4, other_score: 0)
      submission_review3 = FactoryBot.create(:submission_review, submission: submission, innovation_score: nil, scope_score: 4, team_score: 5, environment_score: 2, impact_score: 3, budget_score: 0, completion_score: 0, overall_score: 4, other_score: 0)
      expect(submission.unreviewed?).to be false
      expect(submission.composite_score).to eq (31.to_f / 10).round(2)
      expect(submission.overall_score_average).to eq (11.to_f / 3).round(2)
    end

    it 'returns 0s when there are unscored reviews' do
      unscored_review   = FactoryBot.create(:submission_review, submission: submission, innovation_score: 0, scope_score: 0, team_score: 0, environment_score: 0, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 0, other_score: 0)
      unscored_review2  = FactoryBot.create(:submission_review, submission: submission, innovation_score: 0, scope_score: 0, team_score: 0, environment_score: 0, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 0, other_score: 0)
      expect(submission.unreviewed?).to be false
      expect(submission.composite_score).to eq 0
      expect(submission.overall_score_average).to eq 0
    end

    it 'calculates when there are scored and unscored reviews' do
      submission_review  = FactoryBot.create(:submission_review, submission: submission, innovation_score: 5, scope_score: 4, team_score: 1, environment_score: 1, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 3, other_score: 0)
      submission_review2 = FactoryBot.create(:submission_review, submission: submission, innovation_score: 9, scope_score: 4, team_score: 5, environment_score: 2, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 4, other_score: 0)
      submission_review3 = FactoryBot.create(:submission_review, submission: submission, innovation_score: 3, scope_score: 4, team_score: 5, environment_score: 2, impact_score: 3, budget_score: 0, completion_score: 0, overall_score: 4, other_score: 0)
      unscored_review    = FactoryBot.create(:submission_review, submission: submission, innovation_score: 0, scope_score: 0, team_score: 0, environment_score: 0, impact_score: 0, budget_score: 0, completion_score: 0, overall_score: 0, other_score: 0)
      expect(submission.unreviewed?).to be false
      expect(submission.composite_score).to eq 48.fdiv(13).round(2)
      expect(submission.overall_score_average).to eq 11.fdiv(3).round(2)
    end
  end

end
