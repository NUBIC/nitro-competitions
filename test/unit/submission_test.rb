# == Schema Information
# Schema version: 20130511121216
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
#  created_at                        :datetime
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
#  updated_at                        :datetime
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

require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "submission nil validations" do
     submission = Submission.new(:direct_project_cost => 10)

     assert !submission.nil? 
     assert !submission.valid? 
     assert submission.errors.invalid?(:direct_project_cost) 
     assert submission.errors.invalid?(:submission_title) 
   end

   test "submission has project" do
     submission = submissions(:one)

     assert !submission.nil? 
     assert submission.valid? 
     assert !submission.project.blank?
  end

  test "submission has applicant" do
    submission = submissions(:one)

    assert !submission.applicant.blank?
  end

  test "submission is submitter" do
    submission = submissions(:one)

    assert !submission.submitter.blank?
  end

  test "user is effort_approver" do
    submission = submissions(:one)
    
    # since effort_approver_username is used this will be blank until we refactor to effort_approver_id

    assert submission.effort_approver.blank?
  end

  test "user is department_administrator" do
    submission = submissions(:one)
    
    # since department_administrator_username is used this will be blank until we refactor to effort_approver_id

    assert submission.department_administrator.blank?
  end

  test "user is core_manager" do
    submission = submissions(:one)
    
    # since core_manager_username is used this will be blank until we refactor to effort_approver_id

    assert submission.core_manager.blank?
  end
  
  
  test "submission has submission_reviews" do
    submission = submissions(:one)

    assert !submission.submission_reviews.blank?
    assert submission.submission_reviews.length > 0
  end

  test "submission has reviewers" do
    submission = submissions(:one)

    assert !submission.reviewers.blank?
    assert submission.reviewers.length > 0
  end
  
  
  test "submission has key_personnel" do
    submission = submissions(:one)

    assert !submission.key_personnel.blank?
    assert submission.key_personnel.length > 0
  end

  test "recent submissions" do
    submission1 = submissions(:one)
    submission2 = submissions(:two)
    submissions = Submission.recent
    assert !submissions.blank?
    assert submissions.length > 0
    assert submissions.collect(&:id).include?(submission1.id)
    assert submissions.collect(&:id).include?(submission2.id)
 
  end

  test "submission has key_people" do
    submission = submissions(:one)

    assert !submission.nil? 
    assert !submission.key_people.blank?
    assert submission.key_people.length > 0
    assert !submission.key_personnel.blank?
    assert submission.key_personnel.length > 0
    key_personnel = submission.key_personnel
    key_people = submission.key_people
    key_people.each do |user|
      assert key_personnel.collect(&:user_id).include?(user.id)
    end
  end


end
