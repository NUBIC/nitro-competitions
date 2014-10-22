# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20141022182109
#
# Table name: projects
#
#  abstract_text                       :string(255)      default("Please include an abstract of your proposal, not to exceed 200 words.")
#  applicant_abbreviation_wording      :text             default("PI")
#  applicant_wording                   :text             default("Principal Investigator")
#  application_doc_description         :string(255)      default("Please upload the completed application here.")
#  application_doc_name                :string(255)      default("Application")
#  application_info_url                :string(255)
#  application_info_url_label          :string(255)      default("Application instructions")
#  application_template_url            :string(255)
#  application_template_url_label      :string(255)      default("Application template")
#  budget_info_url                     :string(255)
#  budget_info_url_label               :string(255)      default("Budget instructions")
#  budget_template_url                 :string(255)
#  budget_template_url_label           :string(255)      default("Budget template")
#  budget_title                        :string(255)      default("Budget")
#  budget_wording                      :text             default("Is the budget reasonable and appropriate for the request?")
#  category_wording                    :text             default("Core Facility Name")
#  closed_status_wording               :string(255)      default("Awarded")
#  completion_title                    :string(255)      default("Completion")
#  completion_wording                  :text             default("Is the project plan laid out so that the majority of the specific aims can be carried out in the specified time? Is there a reasonable expectation that the aims are reasonable and well tied into the objectives and approach?")
#  created_at                          :datetime         not null
#  created_id                          :integer
#  created_ip                          :string(255)
#  deleted_at                          :datetime
#  deleted_id                          :integer
#  deleted_ip                          :string(255)
#  department_administrator_title      :text             default("Financial contact person")
#  direct_project_cost_wording         :text             default("Direct project cost")
#  document1_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document1_info_url                  :string(255)
#  document1_name                      :string(255)      default("Replace with document name, like ''OSR-1 form''")
#  document1_template_url              :string(255)
#  document2_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document2_info_url                  :string(255)
#  document2_name                      :string(255)      default("Replace with document name, like ''OSR-1 form''")
#  document2_template_url              :string(255)
#  document3_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document3_info_url                  :string(255)
#  document3_name                      :string(255)      default("Replace with document name, like ''OSR-1 form''")
#  document3_template_url              :string(255)
#  document4_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document4_info_url                  :string(255)
#  document4_name                      :string(255)      default("Replace with document name, like ''OSR-1 form''")
#  document4_template_url              :string(255)
#  effort_approver_title               :text             default("Effort approver")
#  environment_title                   :string(255)      default("Environment")
#  environment_wording                 :text             default("Will the scientific environment in which the work will be done contribute to the probability of success? Are the institutional support, equipment and other physical resources available to the investigators adequate for the project proposed? Will the project benefit from unique features of the scientific environment, subject populations, or collaborative arrangements?")
#  help_document_url_block             :text             default("<a href=\"/docs/Pilot_Proposal_Form.doc\" title=\"Pilot Proposal Form\">Application template</a>\n<a href=\"/docs/Application_Instructions.pdf\" title=\"Pilot Proposal Application Instructions\">Application instructions</a>\n<a href=\"/docs/Pilot_Budget.doc\" title=\"Pilot Proposal Budget Template\">Budget Template</a>\n<a href=\"/docs/Pilot_Budget_Instructions.pdf\" title=\"Pilot Proposal Budget Instructions\">Budget instructions</a>")
#  how_to_url_block                    :text             default("<a href=\"/docs/NITRO ARM_Instructions.pdf\" title=\"NITRO ARM Web Site Instructions/Help/HowTo\">Site instructions</a>")
#  human_subjects_research_text        :text             default("Human subjects research typically includes direct contact with research participants and/or patients. Aggregate data or ''counts'' of patients matching criteria, such as for proposal preparation, it is not typically considered human subjects research.")
#  id                                  :integer          not null, primary key
#  impact_title                        :string(255)      default("Significance")
#  impact_wording                      :text             default("Does the project address an important unmet health need? If the aims of the project are achieved, how will scientific knowledge, technical capability, and/or clinical practice be improved? How will successful completion of the aims change the methods, technologies, treatments, services, or preventative interventions that drive this field?")
#  initiation_date                     :date
#  innovation_title                    :string(255)      default("Innovation")
#  innovation_wording                  :text             default("Does the application challenge and seek to shift current clinical practice paradigms by utilizing novel approaches or methodologies, instrumentation, or interventions? Are the approaches or methodologies, instrumentation, or interventions novel to one field of research or novel in a broad sense? Is a refinement, improvement, or new application of approaches or methodologies, instrumentation, or interventions proposed?")
#  is_new_wording                      :text             default("Is this completely new work?")
#  manage_other_support_text           :string(255)      default("Please include your NIH Other Support document. You can download a sample NIH Other Support document <a href=''http://grants.nih.gov/grants/funding/phs398/othersupport.doc''>here</a>.")
#  max_assigned_proposals_per_reviewer :integer          default(3)
#  max_assigned_reviewers_per_proposal :integer          default(2)
#  max_budget_request                  :float            default(50000.0)
#  membership_required                 :boolean          default(FALSE)
#  min_budget_request                  :float            default(1000.0)
#  only_allow_pdfs                     :boolean          default(FALSE)
#  other_funding_sources_wording       :text             default("Other funding sources")
#  other_title                         :string(255)      default("Additional Review Criteria")
#  other_wording                       :text             default("Are the responses to comments from the previous review group adequate? Are the improvements in the resubmission application appropriate? Are there other issues that should be considered when scoring this application?")
#  overall_impact_description          :text             default("Please summarize the strengths and weaknesses of the application; assess the potential benefit of the instrument requested for the overall research community and its potential impact on NIH-funded research; and provide comments on the overall need of the users which led to their final recommendation and level of enthusiasm.")
#  overall_impact_direction            :text             default("Overall Strengths and Weaknesses:<br/>Please do not exceed 3 paragraphs")
#  overall_impact_title                :string(255)      default("Overall Impact")
#  program_id                          :integer          not null
#  project_description                 :text
#  project_name                        :string(255)      not null
#  project_period_end_date             :date
#  project_period_start_date           :date
#  project_title                       :string(255)      not null
#  project_url                         :string(255)
#  project_url_label                   :string(255)      default("Competition RFA")
#  projects                            :string(255)      default("Please include your NIH Other Support document. You can download a sample NIH Other Support document <a href=''http://grants.nih.gov/grants/funding/phs398/othersupport.doc''>here</a>.")
#  require_era_commons_name            :boolean          default(FALSE)
#  review_end_date                     :date
#  review_guidance_url                 :string(255)      default("../docs/review_criteria.html")
#  review_start_date                   :date
#  rfp_url_block                       :text             default("<a href=\"/docs/CTI_RFA.pdf\" title=\"Pilot Proposal Request for Applications\">CTI RFA</a>")
#  scope_title                         :string(255)      default("Approach")
#  scope_wording                       :text             default("Are the overall strategy, methodology, and analyses well-reasoned and appropriate to accomplish the specific aims of the project? Are potential problems, alternative strategies, and benchmarks for success presented? If the project is in the early stages of development, will the strategy establish feasibility and will particularly risky aspects be managed?")
#  show_abstract_field                 :boolean          default(TRUE)
#  show_application_doc                :boolean          default(TRUE)
#  show_budget_form                    :boolean          default(FALSE)
#  show_budget_score                   :boolean          default(FALSE)
#  show_committee_review_approval      :boolean          default(FALSE)
#  show_completion_score               :boolean          default(FALSE)
#  show_composite_scores_to_applicants :boolean          default(FALSE)
#  show_composite_scores_to_reviewers  :boolean          default(TRUE)
#  show_conflict_explanation           :boolean          default(FALSE)
#  show_core_manager                   :boolean          default(FALSE)
#  show_cost_sharing_amount            :boolean          default(FALSE)
#  show_cost_sharing_organization      :boolean          default(FALSE)
#  show_department_administrator       :boolean          default(FALSE)
#  show_document1                      :boolean          default(FALSE)
#  show_document2                      :boolean          default(FALSE)
#  show_document3                      :boolean          default(FALSE)
#  show_document4                      :boolean          default(FALSE)
#  show_effort_approver                :boolean          default(FALSE)
#  show_environment_score              :boolean          default(TRUE)
#  show_human_subjects_research        :boolean          default(FALSE)
#  show_iacuc_approved                 :boolean          default(FALSE)
#  show_iacuc_study_num                :boolean          default(FALSE)
#  show_impact_score                   :boolean          default(TRUE)
#  show_innovation_score               :boolean          default(TRUE)
#  show_irb_approved                   :boolean          default(FALSE)
#  show_irb_study_num                  :boolean          default(FALSE)
#  show_is_conflict                    :boolean          default(FALSE)
#  show_is_new                         :boolean          default(FALSE)
#  show_manage_biosketches             :boolean          default(FALSE)
#  show_manage_coinvestigators         :boolean          default(FALSE)
#  show_manage_other_support           :boolean          default(TRUE)
#  show_not_new_explanation            :boolean          default(FALSE)
#  show_nucats_cru_contact_name        :boolean          default(FALSE)
#  show_other_funding_sources          :boolean          default(FALSE)
#  show_other_score                    :boolean          default(FALSE)
#  show_previous_support_description   :boolean          default(FALSE)
#  show_project_cost                   :boolean          default(TRUE)
#  show_received_previous_support      :boolean          default(FALSE)
#  show_review_guidance                :boolean          default(TRUE)
#  show_review_summaries_to_applicants :boolean          default(TRUE)
#  show_review_summaries_to_reviewers  :boolean          default(TRUE)
#  show_scope_score                    :boolean          default(TRUE)
#  show_submission_category            :boolean          default(FALSE)
#  show_team_score                     :boolean          default(TRUE)
#  show_use_cmh                        :boolean          default(FALSE)
#  show_use_embryonic_stem_cells       :boolean          default(FALSE)
#  show_use_nmff                       :boolean          default(FALSE)
#  show_use_nmh                        :boolean          default(FALSE)
#  show_use_nucats_cru                 :boolean          default(FALSE)
#  show_use_ric                        :boolean          default(FALSE)
#  show_use_stem_cells                 :boolean          default(FALSE)
#  show_use_va                         :boolean          default(FALSE)
#  show_use_vertebrate_animals         :boolean          default(FALSE)
#  status                              :string(255)
#  submission_category_description     :string(255)      default("Please enter the core you are making this submission for.")
#  submission_close_date               :date
#  submission_modification_date        :date
#  submission_open_date                :date
#  supplemental_document_description   :string(255)      default("Please upload any supplemental information here. (Optional)")
#  supplemental_document_name          :string(255)      default("Supplemental Document (Optional)")
#  team_title                          :string(255)      default("Investigator(s)")
#  team_wording                        :text             default("Are the PIs, collaborators, and other researchers well suited to the project? If Early Stage Investigators or New Investigators, do they have appropriate experience and training? If established, have they demonstrated an ongoing record of accomplishments that have advanced their field(s)? If the project is collaborative, do the investigators have complementary and integrated expertise; are their leadership approach, governance and organizational structure appropriate for the project?")
#  title_wording                       :text             default("Title of Project")
#  updated_at                          :datetime         not null
#  updated_id                          :integer
#  updated_ip                          :string(255)
#

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

    it 'defaults membership_required to false' do
      project.membership_required.should be_false
    end
  end
end
