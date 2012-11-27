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
