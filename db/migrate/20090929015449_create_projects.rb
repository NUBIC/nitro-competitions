class CreateProjects < ActiveRecord::Migration[4.2]
  def self.up
    create_table :projects do |t|
      t.integer :program_id, :null => false
      t.string :project_title, :null => false
      t.string :project_name, :null => false
      t.text :project_description
      t.string :project_url
      t.date :initiation_date
      t.date :submission_open_date
      t.date :submission_close_date
      t.date :submission_modification_date
      t.date :review_start_date
      t.date :review_end_date
      t.date :project_period_start_date
      t.date :project_period_end_date
      t.string :status


      t.float :min_budget_request, :default => 1000
      t.float :max_budget_request, :default => 50000
      t.integer :max_assigned_reviewers_per_proposal, :default => 2
      t.integer :max_assigned_proposals_per_reviewer, :default => 3
      t.text :applicant_wording, :default => 'Principal Investigator'
      t.text :applicant_abbreviation_wording, :default => 'PI'
      t.text :title_wording, :default => 'Title of Project'
      t.text :category_wording, :default => 'Core Facility Name'
      t.text :help_document_url_block, :default => '<a href="/docs/NUCATS_Pilot_Proposal_Form.doc" title="NUCATS Pilot Proposal Form">Application template</a>
      <a href="/docs/Application_Instructions.pdf" title="NUCATS Pilot Proposal Application Instructions">Application instructions</a>
      <a href="/docs/NUCATS_Pilot_Budget.doc" title="NUCATS Pilot Proposal Budget Template">Budget Template</a>
      <a href="/docs/Budget_Instructions.pdf" title="NUCATS Pilot Proposal Budget Instructions">Budget instructions</a>'
      t.text :rfp_url_block, :default => '<a href="/docs/NUCATS_CTI_RFA.pdf" title="NUCATS Pilot Proposal Request for Applications">CTI RFA</a>'
      t.text :how_to_url_block, :default => '<a href="/docs/NUCATS_Assist_Instructions.pdf" title="NUCATS Pilot Proposal Web Site Instructions/Help/HowTo">Site instructions</a>'
      t.text :effort_approver_title, :default => 'Effort approver'
      t.text :department_administrator_title, :default => 'Financial contact person'
      t.text :is_new_wording, :default => 'Is this completely new work?'
      t.text :other_funding_sources_wording, :default => 'Other funding sources'
      t.text :direct_project_cost_wording, :default => 'Direct project cost'

      t.boolean :show_submission_category, :default=>false

      t.boolean :show_core_manager, :default=>false
      t.boolean :show_cost_sharing_amount, :default=>false
      t.boolean :show_cost_sharing_organization, :default=>false
      t.boolean :show_received_previous_support, :default=>false
      t.boolean :show_previous_support_description, :default=>false
      t.boolean :show_committee_review_approval, :default=>false

      t.boolean :show_human_subjects_research, :default=>false
      t.boolean :show_irb_approved, :default=>false
      t.boolean :show_irb_study_num, :default=>false
      t.boolean :show_use_nucats_cru, :default=>false
      t.boolean :show_nucats_cru_contact_name, :default=>false
      t.boolean :show_use_stem_cells, :default=>false
      t.boolean :show_use_embryonic_stem_cells, :default=>false
      t.boolean :show_use_vertebrate_animals, :default=>false
      t.boolean :show_iacuc_approved, :default=>false
      t.boolean :show_iacuc_study_num, :default=>false
      t.boolean :show_is_new, :default=>false
      t.boolean :show_not_new_explanation, :default=>false
      t.boolean :show_use_nmh, :default=>false
      t.boolean :show_use_nmff, :default=>false
      t.boolean :show_use_va, :default=>false
      t.boolean :show_use_ric, :default=>false
      t.boolean :show_use_cmh, :default=>false
      t.boolean :show_other_funding_sources, :default=>false
      t.boolean :show_is_conflict, :default=>false
      t.boolean :show_conflict_explanation, :default=>false
      t.boolean :show_effort_approver, :default=>false
      t.boolean :show_department_administrator, :default=>false
      t.boolean :show_budget_form, :default=>false
      t.boolean :show_manage_coinvestigators, :default=>false
      t.boolean :show_manage_biosketches, :default=>false
      t.boolean :require_era_commons_name, :default=>false

      t.string :review_guidance_url, :default => '/docs/review_criteria.html'
      t.string :overall_impact_title, :default => 'Overall Impact'
      t.text :overall_impact_description, :default => 'Please summarize the strengths and weaknesses of the application; assess the potential benefit of the instrument requested for the overall research community and its potential impact on NIH-funded research; and provide comments on the overall need of the users which led to their final recommendation and level of enthusiasm.'
      t.text :overall_impact_direction, :default => 'Overall Strengths and Weaknesses:<br/>Please do not exceed 3 paragraphs'

      t.boolean :show_impact_score, :default=>true
      t.boolean :show_team_score, :default=>true
      t.boolean :show_innovation_score, :default=>true
      t.boolean :show_scope_score, :default=>true
      t.boolean :show_environment_score, :default=>true
      t.boolean :show_budget_score, :default=>false
      t.boolean :show_completion_score, :default=>false
      t.boolean :show_other_score, :default=>false

      t.string :impact_title, :default => 'Significance'
      t.text :impact_wording, :default => 'Does the project address an important unmet health need? If the aims of the project are achieved, how will scientific knowledge, technical capability, and/or clinical practice be improved? How will successful completion of the aims change the methods, technologies, treatments, services, or preventative interventions that drive this field?'

      t.string :team_title, :default => 'Investigator(s)'
      t.text :team_wording, :default => 'Are the PIs, collaborators, and other researchers well suited to the project? If Early Stage Investigators or New Investigators, do they have appropriate experience and training? If established, have they demonstrated an ongoing record of accomplishments that have advanced their field(s)? If the project is collaborative, do the investigators have complementary and integrated expertise; are their leadership approach, governance and organizational structure appropriate for the project?'

      t.string :innovation_title, :default => 'Innovation'
      t.text :innovation_wording, :default => 'Does the application challenge and seek to shift current clinical practice paradigms by utilizing novel approaches or methodologies, instrumentation, or interventions? Are the approaches or methodologies, instrumentation, or interventions novel to one field of research or novel in a broad sense? Is a refinement, improvement, or new application of approaches or methodologies, instrumentation, or interventions proposed?'

      t.string :scope_title, :default => 'Approach'
      t.text :scope_wording, :default => 'Are the overall strategy, methodology, and analyses well-reasoned and appropriate to accomplish the specific aims of the project? Are potential problems, alternative strategies, and benchmarks for success presented? If the project is in the early stages of development, will the strategy establish feasibility and will particularly risky aspects be managed?'

      t.string :environment_title, :default => 'Environment'
      t.text :environment_wording, :default => 'Will the scientific environment in which the work will be done contribute to the probability of success? Are the institutional support, equipment and other physical resources available to the investigators adequate for the project proposed? Will the project benefit from unique features of the scientific environment, subject populations, or collaborative arrangements?'

      t.string :other_title, :default => 'Additional Review Criteria'
      t.text :other_wording, :default => 'Are the responses to comments from the previous review group adequate? Are the improvements in the resubmission application appropriate? Are there other issues that should be considered when scoring this application?'

      t.string :budget_title, :default => 'Budget'
      t.text :budget_wording, :default => 'Is the budget reasonable and appropriate for the request?'

      t.string :completion_title, :default => 'Completion'
      t.text :completion_wording, :default => 'Is the project plan laid out so that the majority of the specific aims can be carried out in the specified time? Is there a reasonable expectation that the aims are reasonable and well tied into the objectives and approach?'

      t.boolean :show_abstract_field, :default=>true
      t.string :abstract_text, :default=>"Please include an abstract of your proposal, not to exceed 200 words."

      t.boolean :show_manage_other_support, :default=>true
      t.string :projects, :manage_other_support_text, :default=>"Please include your NIH Other Support document. You can download a sample NIH Other Support document <a href='http://grants.nih.gov/grants/funding/phs398/othersupport.doc'>here</a>."

      t.boolean :show_document1, :default=>false
      t.string :document1_name, :default=>"Replace with document name, like 'OSR-1 form'"
      t.string :document1_description, :default=>"Replace with detailed description of the document, the url for a template for the document, etc."
      t.string :document1_template_url
      t.string :document1_info_url
      t.string :project_url_label, :default=>"Competition RFA"
      t.string :application_template_url
      t.string :application_template_url_label, :default=>"Application template"
      t.string :application_info_url
      t.string :application_info_url_label, :default=>"Application instructions"
      t.string :budget_template_url
      t.string :budget_template_url_label, :default=>"Budget template"
      t.string :budget_info_url
      t.string :budget_info_url_label, :default=>"Budget instructions"

      t.boolean :only_allow_pdfs, :default=>false
      t.boolean :show_document2, :default=>false
      t.string :document2_name, :default=>"Replace with document name, like 'OSR-1 form'"
      t.string :document2_description, :default=>"Replace with detailed description of the document, the url for a template for the document, etc."
      t.string :document2_template_url
      t.string :document2_info_url

      t.boolean :show_document3, :default=>false
      t.string :document3_name, :default=>"Replace with document name, like 'OSR-1 form'"
      t.string :document3_description, :default=>"Replace with detailed description of the document, the url for a template for the document, etc."
      t.string :document3_template_url
      t.string :document3_info_url

      t.boolean :show_document4, :default=>false
      t.string :document4_name, :default=>"Replace with document name, like 'OSR-1 form'"
      t.string :document4_description, :default=>"Replace with detailed description of the document, the url for a template for the document, etc."
      t.string :document4_template_url
      t.string :document4_info_url

      t.boolean :show_project_cost, :default=>true
      t.boolean :show_composite_scores_to_applicants, :default=>false
      t.boolean :show_composite_scores_to_reviewers, :default=>true
      t.boolean :show_review_summaries_to_applicants, :default=>true
      t.boolean :show_review_summaries_to_reviewers, :default=>true

      t.string :submission_category_description, :default=>"Please enter the core you are making this submission for."

      t.text :human_subjects_research_text, :default=>"Human subjects research typically includes direct contact with research participants and/or patients. Aggregate data or 'counts' of patients matching criteria, such as for proposal preparation, it is not typically considered human subjects research."

      t.boolean :show_application_doc, :default=>true
      t.string :application_doc_name, :default=>"Application"
      t.string :application_doc_description, :default=>"Please upload the completed application here."

      t.integer   :created_id
      t.string    :created_ip
      t.integer   :updated_id
      t.string    :updated_ip
      t.timestamp :deleted_at
      t.integer   :deleted_id
      t.string    :deleted_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
