# -*- coding: utf-8 -*-
require 'spec_helper'

describe Submission, :type => :model do

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

  it { is_expected.to have_many(:submission_reviews) }
  it { is_expected.to have_many(:reviewers).through(:submission_reviews) }
  it { is_expected.to have_many(:key_personnel) }
  it { is_expected.to have_many(:key_people).through(:key_personnel) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:submission)).to be_an_instance_of(Submission)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:submission)).to be_persisted
  end

  context 'validating' do
    describe 'submission_title' do
      it 'validates it is greater than 6 characters' do
        title = 'x' * 5
        submission = FactoryGirl.build(:submission, :submission_title => title)
        expect(submission).not_to be_valid
        expect(submission.errors[:submission_title]).not_to be_blank
      end
      it 'validates it is less than 81 characters' do
        title = 'x' * 82
        submission = FactoryGirl.build(:submission, :submission_title => title)
        expect(submission).not_to be_valid
        expect(submission.errors[:submission_title]).not_to be_blank
      end
    end
    describe 'direct_project_cost' do
      it 'validates it is within limits' do
        submission = FactoryGirl.build(:submission, :direct_project_cost => 10)
        expect(submission).not_to be_valid
        expect(submission.errors[:direct_project_cost]).not_to be_blank
      end
    end
    describe 'submission_status' do
      it 'validates inclusion in Submission::STATUSES' do
        Submission::STATUSES.each do |s|
          submission = FactoryGirl.build(:submission, :submission_status => "#{s}xxx")
          expect(submission).not_to be_valid
          submission.submission_status = s
          expect(submission).to be_valid
        end
      end
    end
  end

  describe '.recent' do
    it 'returns those submissions created within the last 3 weeks' do
      recent_project = FactoryGirl.create(:project, :project_name => 'recent')
      older_project = FactoryGirl.create(:project, :project_name => 'older')
      recent_submission = FactoryGirl.create(:submission, :created_at => 2.weeks.ago, :project => recent_project)
      older_submission  = FactoryGirl.create(:submission, :created_at => 20.weeks.ago, :project => older_project)

      submissions = Submission.recent
      expect(submissions).not_to be_blank
      expect(submissions).to include(recent_submission)
      expect(submissions).not_to include(older_submission)
    end
  end

end
