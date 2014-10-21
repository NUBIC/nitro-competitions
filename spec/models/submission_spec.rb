# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20140908190758
#
# Table name: submissions
#
#  abstract                          :text
#  applicant_biosketch_document_id   :integer
#  applicant_id                      :integer
#  application_document_id           :integer
#  budget_document_id                :integer
#  committee_review_approval         :boolean          default(FALSE)
#  completion_at                     :datetime
#  conflict_explanation              :text
#  core_manager_username             :string(255)
#  cost_sharing_amount               :float
#  cost_sharing_organization         :text
#  created_at                        :datetime         not null
#  created_id                        :integer
#  created_ip                        :string(255)
#  deleted_at                        :datetime
#  deleted_id                        :integer
#  deleted_ip                        :string(255)
#  department_administrator_username :string(255)
#  direct_project_cost               :float
#  document1_id                      :integer
#  document2_id                      :integer
#  document3_id                      :integer
#  document4_id                      :integer
#  effort_approval_at                :datetime
#  effort_approver_ip                :string(255)
#  effort_approver_username          :string(255)
#  iacuc_study_num                   :string(255)
#  id                                :integer          not null, primary key
#  irb_study_num                     :string(255)
#  is_conflict                       :boolean
#  is_human_subjects_research        :boolean
#  is_iacuc_approved                 :boolean
#  is_irb_approved                   :boolean
#  is_new                            :boolean
#  not_new_explanation               :text
#  notification_cnt                  :integer          default(0)
#  notification_sent_at              :datetime
#  notification_sent_by_id           :integer
#  notification_sent_to              :string(255)
#  nucats_cru_contact_name           :string(255)
#  other_funding_sources             :text
#  other_support_document_id         :integer
#  previous_support_description      :text
#  project_id                        :integer
#  received_previous_support         :boolean          default(FALSE)
#  submission_at                     :datetime
#  submission_category               :string(255)
#  submission_reviews_count          :integer          default(0)
#  submission_status                 :string(255)
#  submission_title                  :string(255)
#  supplemental_document_id          :integer
#  updated_at                        :datetime         not null
#  updated_id                        :integer
#  updated_ip                        :string(255)
#  use_cmh                           :boolean
#  use_embryonic_stem_cells          :boolean
#  use_nmff                          :boolean
#  use_nmh                           :boolean
#  use_nucats_cru                    :boolean
#  use_ric                           :boolean
#  use_stem_cells                    :boolean
#  use_va                            :boolean
#  use_vertebrate_animals            :boolean
#

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
    describe 'submission_status' do
      it 'validates inclusion in Submission::STATUSES' do
        Submission::STATUSES.each do |s|
          submission = FactoryGirl.build(:submission, :submission_status => "#{s}xxx")
          submission.should_not be_valid
          submission.submission_status = s
          submission.should be_valid
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
      submissions.should_not be_blank
      submissions.should include(recent_submission)
      submissions.should_not include(older_submission)
    end
  end

end
