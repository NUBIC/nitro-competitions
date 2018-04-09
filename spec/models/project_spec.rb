# -*- coding: utf-8 -*-

describe Project, :type => :model do

  it { is_expected.to have_many(:submissions) }
  it { is_expected.to have_many(:submission_reviews).through(:submissions) }
  it { is_expected.to have_many(:logs) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator) }

  it 'can be instantiated' do
    expect(FactoryGirl.build(:project)).to be_an_instance_of(Project)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:project)).to be_persisted
  end

  describe 'a new instance' do
    let(:project) { Project.new }
    it 'is not valid' do
      expect(project).not_to be_nil
      expect(project).not_to be_valid
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
        expect(project.errors).to include(att)
      end
    end
  end

  describe 'a valid instance' do
    let(:project) { FactoryGirl.create(:project) }
    it 'project has relationships' do

      expect(project).not_to be_nil
      expect(project).to be_valid

      expect(project.program).not_to be_nil
      expect(project.creator).not_to be_nil

      # TODO: add these assertions when we create submissions and reviewers
      # assert project.submissions.length > 0
      # assert project.program.reviewers.length > 0
    end

    it 'defaults membership_required to false' do
      expect(project.membership_required).to be_falsey
    end

    it 'requires default scores' do
      expect(project.review_criteria).to match_array(WithScoring::DEFAULT_CRITERIA)
    end
  end

  describe 'criteria' do
    it 'returns correct review criteria array' do
      default_project           = FactoryGirl.create(:project)
      project_with_budget_score = FactoryGirl.create(:project, show_budget_score: true)
      expect(default_project.review_criteria).to match_array (WithScoring::DEFAULT_CRITERIA)
      expect(project_with_budget_score.review_criteria).to match_array (WithScoring::DEFAULT_CRITERIA.dup << 'budget')
    end
  end
end
