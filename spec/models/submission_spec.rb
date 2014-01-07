# -*- coding: utf-8 -*-
require 'spec_helper'

describe Submission do

  it { should belong_to(:project) }
  it { should belong_to(:applicant) }
  it { should belong_to(:submitter) }
  it { should belong_to(:effort_approver) }
  it { should belong_to(:core_manager) }
  it { should belong_to(:department_administrator) }
  it { should belong_to(:applicant_biosketch_document) }
  it { should belong_to(:application_document) }
  it { should belong_to(:budget_document) }
  it { should belong_to(:other_support_document) }
  it { should belong_to(:document1) }
  it { should belong_to(:document2) }
  it { should belong_to(:document3) }
  it { should belong_to(:document4) }

  it { should have_many(:submission_reviews) }
  it { should have_many(:reviewers).through(:submission_reviews) }
  it { should have_many(:key_personnel) }
  it { should have_many(:key_people).through(:key_personnel) }

  it 'can be instantiated' do
    FactoryGirl.build(:submission).should be_an_instance_of(Submission)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:submission).should be_persisted
  end

  context 'validating' do
    describe 'submission_title' do
      it 'validates it is greater than 6 characters' do
        title = 'x' * 5
        submission = FactoryGirl.build(:submission, :submission_title => title)
        submission.should_not be_valid
        submission.errors[:submission_title].should_not be_blank
      end
      it 'validates it is less than 81 characters' do
        title = 'x' * 82
        submission = FactoryGirl.build(:submission, :submission_title => title)
        submission.should_not be_valid
        submission.errors[:submission_title].should_not be_blank
      end
    end
    describe 'direct_project_cost' do
      it 'validates it is within limits' do
        submission = FactoryGirl.build(:submission, :direct_project_cost => 10)
        submission.should_not be_valid
        submission.errors[:direct_project_cost].should_not be_blank
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
      submissions.should_not be_blank
      submissions.should include(recent_submission)
      submissions.should_not include(older_submission)
    end
  end

end
