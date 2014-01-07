# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :project do
    sequence(:project_name) { |n| "project_name#{n}_#{Time.now.to_i}" }
    project_title 'MyStringAloneIsNotLongEnough'
    project_description 'MyString'
    project_url 'MyString'
    association :program, factory: :program
    initiation_date Date.today
    submission_open_date Date.today
    submission_close_date Date.today
    review_start_date Date.today
    review_end_date Date.today
    project_period_start_date Date.today
    project_period_end_date Date.today
    status 'MyString'
    min_budget_request 5000
    max_budget_request 100000
    max_assigned_reviewers_per_proposal 2
    max_assigned_proposals_per_reviewer 2
    applicant_wording 'Principal Investigator'
    association :creater, factory: :user
    created_ip '127.0.0.1'
    created_at Time.now
  end
end
