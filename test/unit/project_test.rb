require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "project nil validations" do
      project = Project.new()

      assert !project.nil? 
      assert !project.valid? 
      assert project.errors.invalid?(:project_title) 
      assert project.errors.invalid?(:project_name) 
      assert project.errors.invalid?(:initiation_date) 
      assert project.errors.invalid?(:submission_open_date) 
      assert project.errors.invalid?(:submission_close_date) 
      assert project.errors.invalid?(:review_start_date) 
      assert project.errors.invalid?(:review_end_date) 
      assert project.errors.invalid?(:project_period_start_date) 
      assert project.errors.invalid?(:project_period_end_date) 
    end

    test "project has relationships" do
      project = projects(:one)

      assert !project.nil? 
      project.valid? 
      #Rails::logger.debug "errors: #{project.errors.full_messages.join('; ')}"
      assert project.valid? 
      assert !project.program.nil? 
      assert !project.creater.nil? 
      assert project.submissions.length > 0
      assert project.program.reviewers.length > 0
   end

  
end
