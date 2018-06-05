# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :project do
    sequence(:project_name) { |n| "pn#{n}_#{Time.now.to_i}" }
    # project_name Faker::TwinPeaks.unique.location
    project_title 'MyStringAloneIsNotLongEnough'
    project_description 'MyString'
    rfa_url 'http://www.northwestern.edu'
    association :program, factory: :program
    project_url = Faker::Internet.url
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
    association :creator, factory: :user
    created_ip '127.0.0.1'
    created_at Time.now
    visible true
  end
end
