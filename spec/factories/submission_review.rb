# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :submission_review do
    association :submission, factory: :submission
    association :reviewer, factory: :user
    review_score 1.5
    review_text 'MyText'
    review_doc nil
    review_status 'MyString'
    review_completed_at '2009-09-30 16:02:57'
    innovation_score 1
    impact_score 1
    scope_score 1
    team_score 1
    environment_score 1
    budget_score 1
    completion_score 1
    overall_score 1
    other_score 1
  end
end