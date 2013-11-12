# == Schema Information
# Schema version: 20130511121216
#
# Table name: reviewers
#
#  created_at :datetime
#  created_id :integer
#  created_ip :string(255)
#  deleted_at :datetime
#  deleted_id :integer
#  deleted_ip :string(255)
#  id         :integer          not null, primary key
#  program_id :integer
#  updated_at :datetime
#  updated_id :integer
#  updated_ip :string(255)
#  user_id    :integer
#

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
