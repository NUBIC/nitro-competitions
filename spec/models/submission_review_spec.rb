require 'spec_helper'

describe SubmissionReview do

  it { should belong_to(:submission) }
  it { should have_one(:applicant) }
  it { should have_one(:project) }
  it { should belong_to(:reviewer) }
  it { should belong_to(:user) }

  it 'can be instantiated' do
    FactoryGirl.build(:submission_review).should be_an_instance_of(SubmissionReview)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:submission_review).should be_persisted
  end
end
