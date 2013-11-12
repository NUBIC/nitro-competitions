# == Schema Information
# Schema version: 20130511121216
#
# Table name: submission_reviews
#
#  accepted_at                     :datetime
#  assigned_at                     :datetime
#  assignment_notification_cnt     :integer          default(0)
#  assignment_notification_id      :integer
#  assignment_notification_sent_at :datetime
#  budget_score                    :integer          default(0)
#  budget_text                     :text
#  completion_score                :integer          default(0)
#  created_at                      :datetime
#  created_id                      :integer
#  created_ip                      :string(255)
#  deleted_at                      :datetime
#  deleted_id                      :integer
#  deleted_ip                      :string(255)
#  environment_score               :integer          default(0)
#  environment_text                :text
#  id                              :integer          not null, primary key
#  impact_score                    :integer          default(0)
#  impact_text                     :text
#  innovation_score                :integer          default(0)
#  innovation_text                 :text
#  other_score                     :integer          default(0)
#  other_text                      :text
#  overall_score                   :integer          default(0)
#  overall_text                    :text
#  review_completed_at             :datetime
#  review_doc                      :binary
#  review_score                    :float
#  review_status                   :string(255)
#  review_text                     :text
#  reviewer_id                     :integer
#  scope_score                     :integer          default(0)
#  scope_text                      :text
#  submission_id                   :integer
#  team_score                      :integer          default(0)
#  team_text                       :text
#  thank_you_sent_at               :datetime
#  thank_you_sent_id               :integer
#  updated_at                      :datetime
#  updated_id                      :integer
#  updated_ip                      :string(255)
#

require 'test_helper'

class SubmissionReviewTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "submission review exists" do
    submission_reviews = SubmissionReview.all

    assert !submission_reviews.blank?
    assert submission_reviews.length > 0
    submission_reviews.each do |submission_review|
      assert !submission_review.submission.blank?
      assert !submission_review.reviewer.blank?
      assert !submission_review.user.blank?
      assert submission_review.user == submission_review.reviewer
      assert !submission_review.applicant.blank?
      assert !submission_review.project.blank?
    end
  end
 
  test "submission review belongs to project" do
    project = submission_reviews(:one).project
    submission_reviews = SubmissionReview.this_project(project.id)
    assert submission_reviews.length > 0
    submission_reviews.each do |submission_review|
      assert !submission_review.submission.blank?
      assert !submission_review.submission.project.blank?
      assert submission_review.submission.project == project
    end
  end
  
  test "submission review for active projects" do
    projects = Project.all
    submission_reviews = SubmissionReview.active(projects)
    assert submission_reviews.length > 0
    submission_reviews.each do |submission_review|
      assert !submission_review.submission.blank?
      assert !submission_review.submission.project.blank?
      assert projects.include?(submission_review.submission.project)
    end
  end

  test "submission review scores" do
    submission_review = submission_reviews(:one)
    assert !submission_review.innovation_score.blank?
    assert submission_review.innovation_score > 0
    assert !submission_review.impact_score.blank?
    assert submission_review.impact_score > 0
    assert !submission_review.scope_score.blank?
    assert submission_review.scope_score > 0
    assert !submission_review.team_score.blank?
    assert submission_review.team_score > 0
    assert !submission_review.environment_score.blank?
    assert submission_review.environment_score > 0
    assert !submission_review.other_score.blank?
    assert submission_review.other_score > 0
    assert !submission_review.budget_score.blank?
    assert submission_review.budget_score > 0
    assert !submission_review.overall_score.blank?
    assert submission_review.overall_score > 0
    assert !submission_review.review_score.blank?
    assert submission_review.review_score > 0
    assert submission_review.composite_score > 0
    assert !submission_review.has_zero?
    assert submission_review.count_nonzeros? > 5
    
  end
  
  test "new submission_review scores" do
    submission_review = SubmissionReview.new
    assert !submission_review.innovation_score.blank?
    assert submission_review.innovation_score == 0
    assert !submission_review.impact_score.blank?
    assert submission_review.impact_score == 0
    assert !submission_review.scope_score.blank?
    assert submission_review.scope_score == 0
    assert !submission_review.team_score.blank?
    assert submission_review.team_score == 0
    assert !submission_review.environment_score.blank?
    assert submission_review.environment_score == 0
    assert !submission_review.other_score.blank?
    assert submission_review.other_score == 0
    assert !submission_review.budget_score.blank?
    assert submission_review.budget_score == 0
    assert !submission_review.overall_score.blank?
    assert submission_review.overall_score == 0
    # no default for review_score
    assert submission_review.review_score.blank?
    assert submission_review.composite_score == 0
    assert submission_review.has_zero?
    assert submission_review.count_nonzeros? == 0

  end

end
