require 'spec_helper'

describe Project do

  it { should have_many(:submissions) }
  it { should have_many(:submission_reviews).through(:submissions) }
  it { should have_many(:logs) }
  it { should belong_to(:program) }
  it { should belong_to(:creater) }

  it 'can be instantiated' do
    FactoryGirl.build(:project).should be_an_instance_of(Project)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:project).should be_persisted
  end

  describe 'a new instance' do
    let(:project) { Project.new }
    it 'is not valid' do
      project.should_not be_nil
      project.should_not be_valid
      [
        :project_title,
        :project_name,
        :initiation_date,
        :submission_open_date,
        :submission_close_date,
        :review_start_date,
        :review_end_date,
        :project_period_start_date,
        :project_period_end_date
      ].each do |att|
          project.errors.should include(att)
        end
    end
  end

  describe 'a valid instance' do
    let(:project) { FactoryGirl.create(:project) }
    it 'project has relationships' do

      project.should_not be_nil
      project.should be_valid

      project.program.should_not be_nil
      project.creater.should_not be_nil

      # TODO: add these assertions when we create submissions and reviewers
      # assert project.submissions.length > 0
      # assert project.program.reviewers.length > 0
   end

  end

end