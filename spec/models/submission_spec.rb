require 'spec_helper'

describe Submission do

  it { should belong_to(:project) }
  it { should belong_to(:applicant) }
  it { should belong_to(:submitter) }
  it { should belong_to(:effort_approver) }
  it { should belong_to(:core_manager) }
  it { should belong_to(:department_administrator) }
  it { should belong_to(:applicant_biosketch_document) }
  it { should belong_to(:application_document) }
  it { should belong_to(:budget_document) }
  it { should belong_to(:other_support_document) }
  it { should belong_to(:document1) }
  it { should belong_to(:document2) }
  it { should belong_to(:document3) }
  it { should belong_to(:document4) }

  it { should have_many(:submission_reviews) }
  it { should have_many(:reviewers).through(:submission_reviews) }
  it { should have_many(:key_personnel) }
  it { should have_many(:key_people).through(:key_personnel) }

  it 'can be instantiated' do
    FactoryGirl.build(:submission).should be_an_instance_of(Submission)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:submission).should be_persisted
  end
end
