# -*- coding: utf-8 -*-
FactoryBot.define do
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

    factory :pre_initiated_project do
      project_title 'Pre-Initiated Project'
      initiation_date 1.week.from_now
      submission_open_date 2.week.from_now
      submission_close_date 3.week.from_now
      review_start_date 3.week.from_now
      review_end_date 4.week.from_now
      project_period_start_date 4.week.from_now
      project_period_end_date 5.week.from_now
    end

    factory :initiated_project do 
      project_title 'Initiated Project'
      initiation_date 1.day.ago
      submission_open_date 1.week.from_now
      submission_close_date 2.week.from_now
      review_start_date 2.week.from_now
      review_end_date 3.week.from_now
      project_period_start_date 3.week.from_now 
      project_period_end_date 4.week.from_now
    end

    factory :open_project  do 
      project_title 'Open Project'
      initiation_date 1.day.ago
      submission_open_date 1.day.ago
      submission_close_date 1.week.from_now
      review_start_date 1.week.from_now
      review_end_date 2.week.from_now
      project_period_start_date 2.week.from_now
      project_period_end_date 3.week.from_now
    end

    factory :closed_project do 
      project_title 'Closed Project'
      initiation_date 3.week.ago
      submission_open_date 2.week.ago
      submission_close_date 1.day.ago
      review_start_date 1.day.ago
      review_end_date 1.week.from_now
      project_period_start_date 1.week.from_now
      project_period_end_date 2.week.from_now
    end
  end
end
