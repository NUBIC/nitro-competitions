# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :submission do
    association :project, factory: :project
    association :applicant, factory: :user
    association :submitter, factory: :user
    submission_title 'MyString'
    submission_status 'Pending'
    is_human_subjects_research true
    is_irb_approved true
    irb_study_num 'STU00001234'
    use_nucats_cru false
    use_vertebrate_animals false
    direct_project_cost 5000
    is_new true
    use_nmh true
    not_new_explanation 'MyString'
    other_funding_sources 'TheJones'
    is_conflict false
    association :effort_approver, factory: :user
    effort_approval_at '2009-09-28 20:54:54'
    effort_approver_ip '127.0.0.1'
    association :department_administrator, factory: :user
    association :core_manager, factory: :user
    association :application_document, factory: :file_document
    association :budget_document, factory: :file_document
    association :other_support_document, factory: :file_document
    association :document1, factory: :file_document
    submission_category 'PopTarts'
    cost_sharing_amount 10
    cost_sharing_organization 'NUCATS'
    received_previous_support false
    previous_support_description 'none'
    committee_review_approval true
    abstract 'ThisIsTheTimeForAllGoodPeople'
    submission_at '2009-09-28 20:54:54'
    completion_at '2009-09-28 20:54:54'
  end
end