require 'test_helper'

class ReviewerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  test "reviewer has program" do
    reviewer = reviewers(:one)

    assert !reviewer.nil? 
    assert !reviewer.user.blank?
    assert !reviewer.program.blank?
  end

  test "reviewers have programs" do
    reviewers = Reviewer.all
    reviewers.each do |reviewer|
      assert !reviewer.nil? 
      assert !reviewer.user.blank?
      assert !reviewer.program.blank?
    end
  end
  
end
