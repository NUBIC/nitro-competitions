# -*- coding: utf-8 -*-

describe Project, :type => :model do

  it { is_expected.to have_many(:submissions) }
  it { is_expected.to have_many(:submission_reviews).through(:submissions) }
  it { is_expected.to have_many(:logs) }
  it { is_expected.to belong_to(:program) }
  it { is_expected.to belong_to(:creator) }

  describe 'validation of length on varchars for project' do
    let(:project) { FactoryGirl.create(:project) }
    it "validates length of varchars" do
      varchar_attributes = [:status,
                            :rfa_url,
                            :review_guidance_url,
                            :overall_impact_title,
                            :impact_title,
                            :team_title,
                            :innovation_title,
                            :scope_title,
                            :environment_title,
                            :other_title,
                            :budget_title,
                            :completion_title,
                            :project_name,
                            :abstract_text,
                            :manage_other_support_text,
                            :document1_name,
                            :document1_description,
                            :document1_template_url,
                            :document1_info_url,
                            :project_url_label,
                            :application_template_url,
                            :application_template_url_label,
                            :application_info_url,
                            :application_info_url_label,
                            :budget_template_url,
                            :budget_template_url_label,
                            :budget_info_url,
                            :budget_info_url_label,
                            :document2_name,
                            :document2_description,
                            :document2_template_url,
                            :document2_info_url,
                            :document3_name,
                            :document3_description,
                            :document3_template_url,
                            :document3_info_url,
                            :document4_name,
                            :document4_description,
                            :document4_template_url,
                            :document4_info_url,
                            :submission_category_description,
                            :human_subjects_research_text,
                            :application_doc_name,
                            :application_doc_description,
                            :supplemental_document_name,
                            :supplemental_document_description,
                            :closed_status_wording,
                            :total_amount_requested_wording,
                            :type_of_equipment_wording]
      varchar_attributes.each do |att|
        expect(project).to validate_length_of(att)
      end
    end
  end

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

  describe 'an invalid project' do
    it 'rejects a one character project_name' do
      project = FactoryGirl.build(:project, project_name: 'a')
      expect(project).not_to be_valid
      expect(project.errors).to include(:project_name)
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
