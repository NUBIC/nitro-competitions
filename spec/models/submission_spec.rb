# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: submissions
#
#  id                                :integer          not null, primary key
#  project_id                        :integer
#  applicant_id                      :integer
#  submission_title                  :string(255)
#  submission_status                 :string(255)
#  is_human_subjects_research        :boolean
#  is_irb_approved                   :boolean
#  irb_study_num                     :string(255)
#  use_nucats_cru                    :boolean
#  nucats_cru_contact_name           :string(255)
#  use_stem_cells                    :boolean
#  use_embryonic_stem_cells          :boolean
#  use_vertebrate_animals            :boolean
#  is_iacuc_approved                 :boolean
#  iacuc_study_num                   :string(255)
#  direct_project_cost               :float
#  is_new                            :boolean
#  use_nmh                           :boolean
#  use_nmff                          :boolean
#  use_va                            :boolean
#  use_ric                           :boolean
#  use_cmh                           :boolean
#  not_new_explanation               :text
#  other_funding_sources             :text
#  is_conflict                       :boolean
#  conflict_explanation              :text
#  effort_approver_ip                :string(255)
#  submission_at                     :datetime
#  completion_at                     :datetime
#  effort_approver_username          :string(255)
#  department_administrator_username :string(255)
#  effort_approval_at                :datetime
#  submission_reviews_count          :integer          default(0)
#  submission_category               :string(255)
#  core_manager_username             :string(255)
#  cost_sharing_amount               :float
#  cost_sharing_organization         :text
#  received_previous_support         :boolean          default(FALSE)
#  previous_support_description      :text
#  committee_review_approval         :boolean          default(FALSE)
#  application_document_id           :integer
#  budget_document_id                :integer
#  abstract                          :text
#  other_support_document_id         :integer
#  document1_id                      :integer
#  document2_id                      :integer
#  document3_id                      :integer
#  document4_id                      :integer
#  applicant_biosketch_document_id   :integer
#  notification_cnt                  :integer          default(0)
#  notification_sent_at              :datetime
#  notification_sent_by_id           :integer
#  notification_sent_to              :string(255)
#  created_id                        :integer
#  created_ip                        :string(255)
#  updated_id                        :integer
#  updated_ip                        :string(255)
#  deleted_at                        :datetime
#  deleted_id                        :integer
#  deleted_ip                        :string(255)
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  supplemental_document_id          :integer
#

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
      it 'validates it is less than 200 characters' do
        title = 'x' * 201
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
