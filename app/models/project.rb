# encoding: UTF-8
# == Schema Information
#
# Table name: projects
#
#  id                                  :integer          not null, primary key
#  program_id                          :integer          not null
#  project_title                       :string(255)      not null
#  project_name                        :string(255)      not null
#  project_description                 :text
#  project_url                         :string(255)
#  initiation_date                     :date
#  submission_open_date                :date
#  submission_close_date               :date
#  submission_modification_date        :date
#  review_start_date                   :date
#  review_end_date                     :date
#  project_period_start_date           :date
#  project_period_end_date             :date
#  status                              :string(255)
#  min_budget_request                  :float            default(1000.0)
#  max_budget_request                  :float            default(50000.0)
#  max_assigned_reviewers_per_proposal :integer          default(2)
#  max_assigned_proposals_per_reviewer :integer          default(3)
#  applicant_wording                   :text             default("Principal Investigator")
#  applicant_abbreviation_wording      :text             default("PI")
#  title_wording                       :text             default("Title of Project")
#  category_wording                    :text             default("Core Facility Name")
#  help_document_url_block             :text             default("<a href=\"/docs/Pilot_Proposal_Form.doc\" title=\"Pilot Proposal Form\">Application template</a>\n<a href=\"/docs/Application_Instructions.pdf\" title=\"Pilot Proposal Application Instructions\">Application instructions</a>\n<a href=\"/docs/Pilot_Budget.doc\" title=\"Pilot Proposal Budget Template\">Budget Template</a>\n<a href=\"/docs/Pilot_Budget_Instructions.pdf\" title=\"Pilot Proposal Budget Instructions\">Budget instructions</a>")
#  rfp_url_block                       :text             default("<a href=\"/docs/CTI_RFA.pdf\" title=\"Pilot Proposal Request for Applications\">CTI RFA</a>")
#  how_to_url_block                    :text             default("<a href=\"/docs/NITRO-Competitions_Instructions.pdf\" title=\"NITRO-Competitions Web Site Instructions/Help/HowTo\">Site instructions</a>")
#  effort_approver_title               :text             default("Effort approver")
#  department_administrator_title      :text             default("Financial contact person")
#  is_new_wording                      :text             default("Is this completely new work?")
#  other_funding_sources_wording       :text             default("Other funding sources")
#  direct_project_cost_wording         :text             default("Direct project cost")
#  show_submission_category            :boolean          default(FALSE)
#  show_core_manager                   :boolean          default(FALSE)
#  show_cost_sharing_amount            :boolean          default(FALSE)
#  show_cost_sharing_organization      :boolean          default(FALSE)
#  show_received_previous_support      :boolean          default(FALSE)
#  show_previous_support_description   :boolean          default(FALSE)
#  show_committee_review_approval      :boolean          default(FALSE)
#  show_human_subjects_research        :boolean          default(FALSE)
#  show_irb_approved                   :boolean          default(FALSE)
#  show_irb_study_num                  :boolean          default(FALSE)
#  show_use_nucats_cru                 :boolean          default(FALSE)
#  show_nucats_cru_contact_name        :boolean          default(FALSE)
#  show_use_stem_cells                 :boolean          default(FALSE)
#  show_use_embryonic_stem_cells       :boolean          default(FALSE)
#  show_use_vertebrate_animals         :boolean          default(FALSE)
#  show_iacuc_approved                 :boolean          default(FALSE)
#  show_iacuc_study_num                :boolean          default(FALSE)
#  show_is_new                         :boolean          default(FALSE)
#  show_not_new_explanation            :boolean          default(FALSE)
#  show_use_nmh                        :boolean          default(FALSE)
#  show_use_nmff                       :boolean          default(FALSE)
#  show_use_va                         :boolean          default(FALSE)
#  show_use_ric                        :boolean          default(FALSE)
#  show_use_cmh                        :boolean          default(FALSE)
#  show_other_funding_sources          :boolean          default(FALSE)
#  show_is_conflict                    :boolean          default(FALSE)
#  show_conflict_explanation           :boolean          default(FALSE)
#  show_effort_approver                :boolean          default(FALSE)
#  show_department_administrator       :boolean          default(FALSE)
#  show_budget_form                    :boolean          default(FALSE)
#  show_manage_coinvestigators         :boolean          default(FALSE)
#  show_manage_biosketches             :boolean          default(FALSE)
#  require_era_commons_name            :boolean          default(FALSE)
#  review_guidance_url                 :string(255)      default("/docs/review_criteria.html")
#  overall_impact_title                :string(255)      default("Overall Impact")
#  overall_impact_description          :text             default("Please summarize the strengths and weaknesses of the application; assess the potential benefit of the instrument requested for the overall research community and its potential impact on NIH-funded research; and provide comments on the overall need of the users which led to their final recommendation and level of enthusiasm.")
#  overall_impact_direction            :text             default("Overall Strengths and Weaknesses:<br/>Please do not exceed 3 paragraphs")
#  show_impact_score                   :boolean          default(TRUE)
#  show_team_score                     :boolean          default(TRUE)
#  show_innovation_score               :boolean          default(TRUE)
#  show_scope_score                    :boolean          default(TRUE)
#  show_environment_score              :boolean          default(TRUE)
#  show_budget_score                   :boolean          default(FALSE)
#  show_completion_score               :boolean          default(FALSE)
#  show_other_score                    :boolean          default(FALSE)
#  impact_title                        :string(255)      default("Significance")
#  impact_wording                      :text             default("Does the project address an important unmet health need? If the aims of the project are achieved, how will scientific knowledge, technical capability, and/or clinical practice be improved? How will successful completion of the aims change the methods, technologies, treatments, services, or preventative interventions that drive this field?")
#  team_title                          :string(255)      default("Investigator(s)")
#  team_wording                        :text             default("Are the PIs, collaborators, and other researchers well suited to the project? If Early Stage Investigators or New Investigators, do they have appropriate experience and training? If established, have they demonstrated an ongoing record of accomplishments that have advanced their field(s)? If the project is collaborative, do the investigators have complementary and integrated expertise; are their leadership approach, governance and organizational structure appropriate for the project?")
#  innovation_title                    :string(255)      default("Innovation")
#  innovation_wording                  :text             default("Does the application challenge and seek to shift current clinical practice paradigms by utilizing novel approaches or methodologies, instrumentation, or interventions? Are the approaches or methodologies, instrumentation, or interventions novel to one field of research or novel in a broad sense? Is a refinement, improvement, or new application of approaches or methodologies, instrumentation, or interventions proposed?")
#  scope_title                         :string(255)      default("Approach")
#  scope_wording                       :text             default("Are the overall strategy, methodology, and analyses well-reasoned and appropriate to accomplish the specific aims of the project? Are potential problems, alternative strategies, and benchmarks for success presented? If the project is in the early stages of development, will the strategy establish feasibility and will particularly risky aspects be managed?")
#  environment_title                   :string(255)      default("Environment")
#  environment_wording                 :text             default("Will the scientific environment in which the work will be done contribute to the probability of success? Are the institutional support, equipment and other physical resources available to the investigators adequate for the project proposed? Will the project benefit from unique features of the scientific environment, subject populations, or collaborative arrangements?")
#  other_title                         :string(255)      default("Additional Review Criteria")
#  other_wording                       :text             default("Are the responses to comments from the previous review group adequate? Are the improvements in the resubmission application appropriate? Are there other issues that should be considered when scoring this application?")
#  budget_title                        :string(255)      default("Budget")
#  budget_wording                      :text             default("Is the budget reasonable and appropriate for the request?")
#  completion_title                    :string(255)      default("Completion")
#  completion_wording                  :text             default("Is the project plan laid out so that the majority of the specific aims can be carried out in the specified time? Is there a reasonable expectation that the aims are reasonable and well tied into the objectives and approach?")
#  show_abstract_field                 :boolean          default(TRUE)
#  abstract_text                       :string(255)      default("Please include an abstract of your proposal, not to exceed 200 words.")
#  show_manage_other_support           :boolean          default(TRUE)
#  projects                            :string(255)      default("Please include your NIH Other Support document. You can download a sample NIH Other Support document <a href='http://grants.nih.gov/grants/funding/phs398/othersupport.doc'>here</a>.")
#  manage_other_support_text           :string(255)      default("Please include your NIH Other Support document. You can download a sample NIH Other Support document <a href='http://grants.nih.gov/grants/funding/phs398/othersupport.doc'>here</a>.")
#  show_document1                      :boolean          default(FALSE)
#  document1_name                      :string(255)      default("Replace with document name, like 'OSR-1 form'")
#  document1_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document1_template_url              :string(255)
#  document1_info_url                  :string(255)
#  project_url_label                   :string(255)      default("Competition RFA")
#  application_template_url            :string(255)
#  application_template_url_label      :string(255)      default("Application template")
#  application_info_url                :string(255)
#  application_info_url_label          :string(255)      default("Application instructions")
#  budget_template_url                 :string(255)
#  budget_template_url_label           :string(255)      default("Budget template")
#  budget_info_url                     :string(255)
#  budget_info_url_label               :string(255)      default("Budget instructions")
#  only_allow_pdfs                     :boolean          default(FALSE)
#  show_document2                      :boolean          default(FALSE)
#  document2_name                      :string(255)      default("Replace with document name, like 'OSR-1 form'")
#  document2_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document2_template_url              :string(255)
#  document2_info_url                  :string(255)
#  show_document3                      :boolean          default(FALSE)
#  document3_name                      :string(255)      default("Replace with document name, like 'OSR-1 form'")
#  document3_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document3_template_url              :string(255)
#  document3_info_url                  :string(255)
#  show_document4                      :boolean          default(FALSE)
#  document4_name                      :string(255)      default("Replace with document name, like 'OSR-1 form'")
#  document4_description               :string(255)      default("Replace with detailed description of the document, the url for a template for the document, etc.")
#  document4_template_url              :string(255)
#  document4_info_url                  :string(255)
#  show_project_cost                   :boolean          default(TRUE)
#  show_composite_scores_to_applicants :boolean          default(FALSE)
#  show_composite_scores_to_reviewers  :boolean          default(TRUE)
#  show_review_summaries_to_applicants :boolean          default(TRUE)
#  show_review_summaries_to_reviewers  :boolean          default(TRUE)
#  submission_category_description     :string(255)      default("Please enter the core you are making this submission for.")
#  human_subjects_research_text        :text             default("Human subjects research typically includes direct contact with research participants and/or patients. Aggregate data or 'counts' of patients matching criteria, such as for proposal preparation, it is not typically considered human subjects research.")
#  show_application_doc                :boolean          default(TRUE)
#  application_doc_name                :string(255)      default("Application")
#  application_doc_description         :string(255)      default("Please upload the completed application here.")
#  created_id                          :integer
#  created_ip                          :string(255)
#  updated_id                          :integer
#  updated_ip                          :string(255)
#  deleted_at                          :datetime
#  deleted_id                          :integer
#  deleted_ip                          :string(255)
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  membership_required                 :boolean          default(FALSE)
#  supplemental_document_name          :string(255)      default("Supplemental Document (Optional)")
#  supplemental_document_description   :string(255)      default("Please upload any supplemental information here. (Optional)")
#  closed_status_wording               :string(255)      default("Awarded")
#  show_review_guidance                :boolean          default(TRUE)
#  comment_review_only                 :boolean          default(FALSE)
#  custom_review_guidance              :text
#  strict_deadline                     :boolean          default(FALSE)
#  show_review_scores_to_reviewers     :boolean          default(FALSE)
#  show_total_amount_requested         :boolean          default(FALSE)
#  total_amount_requested_wording      :string
#  show_type_of_equipment              :boolean          default(FALSE)
#  type_of_equipment_wording           :string
#

class Project < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :program
  belongs_to :creator, :class_name => "User", :foreign_key => "created_id"
  has_many :submissions
  has_many :submission_reviews, :through => :submissions
  has_many :logs
  before_validation :clean_params
  before_create :set_defaults

  validates_length_of :project_title, :within => 10..255, :too_long => "--- pick a shorter title", :too_short => "--- pick a longer title"
  validates_length_of :project_name, :within => 2..25, :too_long => "--- pick a shorter name", :too_short => "--- pick a longer name"
  validates_uniqueness_of :project_name  #simplifies the logic a lot if we force the project names to be absolutely unique
  validates_presence_of :initiation_date, :message => "you must have an initiation date!"
  validates_presence_of :submission_open_date, :message => "you must have a submission open date!"
  validates_presence_of :submission_close_date, :message => "you must have a submission close date!"
  validates_presence_of :review_start_date, :message => "you must have a review start date!"
  validates_presence_of :review_end_date, :message => "you must have a review end date!"
  validates_presence_of :project_period_start_date, :message => "you must have a project start date!"
  validates_presence_of :project_period_end_date, :message => "you must have a project end date!"

  def self.current(*date) 
    where('project_period_start_date >= :date and initiation_date <= :initiation_date', { :date => date.first || 1.day.ago, :initiation_date => 60.days.from_now })
  end
  def self.recent(*date) 
    where('project_period_start_date >= :date and initiation_date <= :date', { :date => date.first || 3.months.ago })
  end
  def self.ongoing_projects(*date) 
    where('project_period_end_date >= :date and project_period_start_date <= :date', { :date => date.first || 1.day.ago })
  end
  def self.active(*date) 
    where('project_period_start_date > :date or review_end_date > :review_end_date', { :date => date.first || 3.months.ago, :review_end_date => 60.days.ago })
  end
  def self.early
    where('projects.initiation_date >= :early', { :early => 30.days.from_now })
  end
  def self.preinitiation
    where(':now between projects.initiation_date - 30 and projects.submission_open_date', { :now => 1.hour.ago })
  end
  def self.open
    where(':now between projects.submission_open_date and projects.submission_close_date', { :now => 1.hour.ago })
  end
  def self.in_review
    where(':now between projects.submission_close_date and projects.review_end_date', { :now => 1.hour.ago })
  end
  def self.recently_awarded
    where('projects.review_end_date between :then and :now', { :now => 1.hour.ago, :then => 80.days.ago })
  end
  def self.late
    where('projects.review_end_date <= :then', { :then => 80.days.ago })
  end

  def self.not_published
    where('projects.visible = false')
  end


  def current_status
    if self.visible == false
      not_published_status
    else
      way_before_today = Date.today - 300
      in_the_future = review_end_date + 1000
      case Date.today
      # The open case is the most important and must be first
      # for it to catch all the open dates.
      when submission_open_date..submission_close_date
        open_submission_status

      # The rest of the cases.
      when review_end_date..in_the_future
        closed_status
      when review_start_date..review_end_date
        under_review_status
      when submission_close_date..review_start_date
        closed_submission_status
      when submission_open_date..submission_close_date
        open_submission_status
      when initiation_date..submission_open_date
        pre_submission_date_status
      when way_before_today..initiation_date
        pre_initiation_date_status
      else
        'Unknown'
      end
    end
  end

  def is_open?
    submission_open_date <= Date.today && submission_close_date >= Date.today
  end
  alias :open? :is_open?

  def is_modifiable?
    submission_modification_date.blank? ? false : submission_modification_date >= Date.today
  end
  alias :modifiable? :is_modifiable?

  def is_reviewable?
    review_end_date.blank? ? false : review_end_date < Date.today
  end
  alias :reviewable? :is_reviewable?

  ##
  # Status shown when today is less than
  # the @initiation_date
  def not_published_status
    'Not published'
  end

  # Status shown when today is less than
  # the @initiation_date
  def pre_initiation_date_status
    'Pre-announcement'
  end

  ##
  # Status shown after initiation but
  # before submissions accepted
  def pre_submission_date_status
    'New announcement'
  end

  ##
  # Status shown when submissions
  # are being accepted
  def open_submission_status
    'Open for Applications'
  end

  ##
  # Status shown when submissions
  # are no longer being accepted
  def closed_submission_status
    'Closed for Review'
  end

  ##
  # Status shown when submissions
  # are being reviewed
  def under_review_status
    'Under Review'
  end

  ##
  # Status shown when the project is no
  # longer
  def closed_status
    closed_status_wording || 'Awarded'
  end

  def count_review_criteria?
    show?(show_impact_score) +
    show?(show_team_score) +
    show?(show_innovation_score) +
    show?(show_scope_score) +
    show?(show_environment_score) +
    show?(show_budget_score) +
    show?(show_completion_score) +
    show?(show_other_score)
  end

  # Submission lists
  def complete_submissions
    submissions.to_a.delete_if {|s| !s.complete? }
  end

  def incomplete_submissions
    submissions.to_a.delete_if {|s| s.complete? }
  end

  
  def show?(val)
    (val.blank? or !val) ? 0 : 1
  end

  def clean_params
    # need the before_type_cast or else Rails 2.3 truncates after any comma. strange
    return unless defined?(self.project_name)

    txt = self.project_name
    return if txt.blank?
    txt = txt.downcase.gsub(/\s/, "").gsub(/[^a-z0-9]/, "_").gsub(/__+/, "_")
    self.project_name = txt
  end

  def project_url
    NucatsAssist.root_url + project_path(self)
  end

  def competition_url
    NucatsAssist.root_url + show_competition_path(self.program.program_name, self.project_name)
  end

  def set_defaults
    self.rfa_url ||= NucatsAssist.root_url + project_path(self)
  end

end
