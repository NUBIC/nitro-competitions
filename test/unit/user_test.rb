require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  test "user nil validations" do
     the_user = User.new()
     the_user.validate_email_attr = true
     the_user.validate_era_commons_name = true

     assert !the_user.nil? 
     assert !the_user.valid? 
     assert the_user.errors.invalid?(:username) 
     assert the_user.errors.invalid?(:first_name) 
     assert the_user.errors.invalid?(:last_name) 
     assert the_user.errors.invalid?(:email) 
     assert the_user.errors.invalid?(:era_commons_name) 

     the_user = User.new()
     the_user.validate_email_attr = false
     the_user.validate_era_commons_name = false

     assert !the_user.errors.invalid?(:email) 
     assert !the_user.errors.invalid?(:era_commons_name) 

     the_user = User.new()
     the_user.validate_email_attr = nil
     the_user.validate_era_commons_name = nil
     assert !the_user.errors.invalid?(:email) 
     assert !the_user.errors.invalid?(:era_commons_name) 
   end

   test "user is project reviewer" do
     the_user = users(:one)

     assert !the_user.nil? 
     assert the_user.valid? 
  end

  test "user is key_personnel" do
    the_user = users(:two)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.key_personnel.blank?
    assert the_user.key_personnel.length > 0
    assert the_user == the_user.key_personnel[0].user
  end
  
  test "user is program reviewer" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.reviewers.blank?
    assert the_user.reviewers.length > 0
    assert the_user == the_user.reviewers[0].user
    assert !the_user.reviewers[0].program.blank?
  end

  
  test "user has submission_reviews" do
    the_user = users(:two)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.submission_reviews.blank?
    assert the_user.submission_reviews.length > 0
    assert the_user == the_user.submission_reviews[0].reviewer
  end
  
  
  test "user has reviewed_submissions" do
    the_user = users(:two)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.reviewed_submissions.blank?
    assert the_user.reviewed_submissions.length > 0
  end

  test "user has roles_users and roles" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.roles_users.blank?
    assert the_user.roles_users.length > 0
    assert !the_user.roles_users[0].role.blank?
  end


  test "user has submission and is applicant" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.submissions.blank?
    assert the_user.submissions.length > 0
    the_user.submissions.each do |submission|
      assert !submission.applicant.blank?
      assert the_user == submission.applicant
    end
  end


  test "user has proxy_submissions and is submitter" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.proxy_submissions.blank?
    assert the_user.proxy_submissions.length > 0
    the_user.proxy_submissions.each do |submission|
      assert !submission.submitter.blank?
      assert the_user == submission.submitter
    end
  end

  test "user has submission and a project" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.submissions.blank?
    assert the_user.submissions.length > 0
    assert !the_user.submissions[0].project.blank?
  end


  test "user is a project_applicant" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.submissions.blank?
    assert the_user.submissions.length > 0
    assert !the_user.submissions[0].project.blank?
    project_id = the_user.submissions[0].project_id
    applicants = User.project_applicants(project_id)
    assert applicants.length > 0
    applicants.each do |applicant|
      assert applicant == applicant.submissions[0].applicant
    end
  end

  test "project_applicant for multiple projects" do
    projects = Project.all

    applicants = User.project_applicants(projects)
    assert applicants.length > 0
    applicants.each do |applicant|
      assert applicant == applicant.submissions[0].applicant
    end
  end
  

  test "user is a program_reviewer" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.submissions.blank?
    assert the_user.submissions.length > 0
    assert !the_user.submissions[0].project.blank?
    assert !the_user.submissions[0].project.program.blank?
    program_id = the_user.submissions[0].project.program_id
    reviewers = User.program_reviewers(program_id)
    assert reviewers.length > 0
    reviewers.each do |reviewer|
      assert !reviewer.blank?
    end
  end

  test "user reviewers_on_project" do
    the_user = users(:one)

    assert !the_user.nil? 
    assert the_user.valid? 
    assert !the_user.submissions.blank?
    assert the_user.submissions.length > 0
    assert !the_user.submissions[0].project.blank?
    assert !the_user.submissions[0].project.program.blank?
    program_id = the_user.submissions[0].project.program_id
    program_reviewers = User.program_reviewers(program_id)
    assert program_reviewers.length > 0
  end




end