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
