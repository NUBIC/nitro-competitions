# encoding: UTF-8

class Submission < ApplicationRecord
  belongs_to :project
  belongs_to :applicant,                :class_name => 'User', :foreign_key => 'applicant_id'
  belongs_to :submitter,                :class_name => 'User', :foreign_key => 'created_id'
  belongs_to :effort_approver,          :class_name => 'User', :primary_key => 'username', :foreign_key => 'effort_approver_username'
  belongs_to :core_manager,             :class_name => 'User', :primary_key => 'username', :foreign_key => 'core_manager_username'
  belongs_to :department_administrator, :class_name => 'User', :primary_key => 'username', :foreign_key => 'department_administrator_username'

  belongs_to :applicant_biosketch_document, :class_name => 'FileDocument', :foreign_key => 'applicant_biosketch_document_id'
  belongs_to :application_document,         :class_name => 'FileDocument', :foreign_key => 'application_document_id'
  belongs_to :budget_document,              :class_name => 'FileDocument', :foreign_key => 'budget_document_id'
  belongs_to :other_support_document,       :class_name => 'FileDocument', :foreign_key => 'other_support_document_id'
  belongs_to :document1,                    :class_name => 'FileDocument', :foreign_key => 'document1_id'
  belongs_to :document2,                    :class_name => 'FileDocument', :foreign_key => 'document2_id'
  belongs_to :document3,                    :class_name => 'FileDocument', :foreign_key => 'document3_id'
  belongs_to :document4,                    :class_name => 'FileDocument', :foreign_key => 'document4_id'
  belongs_to :supplemental_document,        :class_name => 'FileDocument', :foreign_key => 'supplemental_document_id'

  # TODO : determine how many supplemental documents are needed or add a join model to associate many documents
  #        (probably will continue to simply add belongs_to relationships to this model)

  has_many :submission_reviews, :dependent => :destroy
  has_many :reviewers, :through => :submission_reviews, :source => :user

  has_many :key_personnel, :class_name => 'KeyPerson'
  has_many :key_people, :through => :key_personnel, :source => :user

  after_save :save_documents

  accepts_nested_attributes_for :applicant
  accepts_nested_attributes_for :key_personnel

  attr_accessor :max_budget_request
  attr_accessor :min_budget_request

  # TODO: determine where submissions need to be ordered and add this at that point
  #       the ordering has been commented out because the joins method is not working
  #       which means that the order on 'users' is causing sql problems
  # TODO: determine if the joins is necessary - this causes the record to be 'readonly' and
  #       will throw an ActiveRecord::ReadOnlyRecord error upon save
  # default_scope joins([:applicant]) #.order('lower(users.last_name), submissions.project_id, lower(submissions.submission_title)')
  scope :assigned_submissions, lambda { where('submission_reviews_count >= 2') }
  scope :unassigned_submissions, lambda { where(:submission_reviews_count => 0) }
  scope :recent, lambda { where('submissions.created_at > ?', 3.weeks.ago) }
  
  scope :filled_submissions, lambda { |*args| where('submission_reviews_count >= :max_reviewers', { :max_reviewers => args.first || 2 }) }
  scope :unfilled_submissions, lambda { |*args| where('submission_reviews_count < :max_reviewers', { :max_reviewers => args.first || 2 }) }

  scope :associated, lambda { |*args|
    includes('submission_reviews')
    .where('(submissions.applicant_id = :id OR submissions.created_id = :id) AND 
            submissions.project_id IN (:projects)', 
      { :projects => args[0], :id => args[1] })
  }

  scope :associated_with_user, lambda { |*args|
    includes('submission_reviews')
    .where('submissions.applicant_id = :id or submissions.created_id = :id', 
      { :id => args.first })
    .order('id asc')
  }

  before_validation :clean_params, :set_defaults

  validates_length_of :submission_title, :within => 6..200, :too_long => '--- pick a shorter title', :too_short => '--- pick a longer title'
  validates_numericality_of :direct_project_cost, :greater_than => 1_000_000, :if => proc { |sub| (sub.direct_project_cost || 0) < sub.min_project_cost && ! sub.direct_project_cost.blank?  }, :message => 'is too low'
  validates_numericality_of :direct_project_cost, :less_than => 1000, :if => proc { |sub| (sub.direct_project_cost || 0) > sub.max_project_cost }, :message => 'is too high'

  # Various values to be set for the `submission_status` attributes
  # presumably depends on the state of the whole of the associated submission_reviews
  PENDING   = 'Pending'
  REVIEWED  = 'Reviewed'
  DENIED    = 'Denied'
  AWARDED   = 'Awarded'
  COMPLETED = 'Completed'
  STATUSES  = [PENDING, REVIEWED, DENIED, AWARDED, COMPLETED]
  EQUIPMENT_TYPES = ['New', 'ReLODE']

  validates :submission_status, inclusion: { in: STATUSES }
  validates :type_of_equipment, inclusion: { in: EQUIPMENT_TYPES }, allow_blank: true

  def overall_scores
    return 0 if submission_reviews.length == 0
    cnt = submission_reviews.map { |s| s.z?(s.overall_score) ? 0 : 1 }.sum
    return 0 if cnt < 1
    (submission_reviews.map { |s| s.z?(s.overall_score) ? 0 : s.overall_score }.sum).to_f / cnt
  end

  def overall_scores_string
    return 0 if submission_reviews.length == 0
    overall_scores.round(2).to_s + ' (' + submission_reviews.map(&:overall_score).join(' & ') + ')'
  end

  def composite_scores
    return 0 if submission_reviews.length == 0
    cnt = submission_reviews.map { |s| s.has_zero? ? 0 : 1 }.sum
    return 0 if cnt < 1
    submission_reviews.map { |s| s.has_zero? ? 0 : s.composite_score }.sum / cnt
  end

  def composite_scores_string
    return 0 if submission_reviews.length == 0
    composite_scores.round(2).to_s + ' (' + submission_reviews.map(&:composite_score).join(' & ') + ')'
  end

  def max_project_cost
    max_budget_request || 50_000
  end

  def min_project_cost
    min_budget_request || 1000
  end

  def status
    return 'Incomplete' if project.blank? || applicant.blank?
    return 'Incomplete' if project.show_project_cost && direct_project_cost.blank?
    return 'Incomplete' if project.show_effort_approver && effort_approver_username.blank?
    return 'Incomplete' if project.show_department_administrator && department_administrator_username.blank?
    return 'Incomplete' if project.show_core_manager && core_manager_username.blank?
    return 'Incomplete' if project.show_abstract_field && abstract.blank?
    return 'Incomplete' if project.show_manage_other_support && other_support_document_id.blank?
    return 'Incomplete' if project.show_document1 && project.document1_required && document1_id.blank?
    return 'Incomplete' if project.show_document2 && project.document2_required && document2_id.blank?
    return 'Incomplete' if project.show_document3 && project.document3_required && document3_id.blank?
    return 'Incomplete' if project.show_document4 && project.document4_required && document4_id.blank?
    return 'Incomplete' if project.show_budget_form && budget_document_id.blank?
    return 'Incomplete' if project.show_manage_biosketches && applicant_biosketch_document_id.blank?
    return 'Incomplete' if project.show_application_doc && application_document_id.blank?
    'Complete'
  end

  def is_complete?
    status == 'Complete'
  end
  alias :complete? :is_complete?

  def is_open?
    project.is_open?
  end
  alias :is_open_submission? :is_open?
  alias :open? :is_open?

  def is_modifiable?
    project.is_modifiable?
  end
  alias :modifiable? :is_modifiable?

  def is_reviewable?
    project.is_reviewable?
  end
  alias :reviewable? :is_reviewable?

  def key_personnel_names
    key_personnel.map { |k| k.name || k.user.name }
  end

  def key_personnel_emails
    key_personnel.map { |k| k.email || k.user.email }
  end

  def status_reason
    out = []
    return ['Project undefined'] if project.blank? || applicant.blank?
    out << 'Project cost is undefined. Please enter a project cost. ' if project.show_project_cost && direct_project_cost.blank?
    out << "#{project.effort_approver_title} unset. Complete in title page. " if project.show_effort_approver && effort_approver_username.blank?
    out << "#{project.department_administrator_title} unset. Complete in title page. " if project.show_department_administrator && department_administrator_username.blank?
    out << 'Core Manager unset. Complete in title page. ' if project.show_core_manager && core_manager_username.blank?
    out << 'Abstract needs to be completed. Complete in title page. ' if project.show_abstract_field && abstract.blank?
    out << 'Manage Other Support document needs to be uploaded. ' if project.show_manage_other_support && other_support_document_id.blank?
    out << "#{project.document1_name} document needs to be uploaded. " if project.show_document1 && project.document1_required && document1_id.blank?
    out << "#{project.document1_name} document is absent but not required. " if project.show_document1 && document1_id.blank?
    out << "#{project.document2_name} document needs to be uploaded. " if project.show_document2 && project.document2_required && document2_id.blank?
    out << "#{project.document2_name} document is absent but not required. " if project.show_document2 && document2_id.blank?
    out << "#{project.document3_name} document needs to be uploaded. " if project.show_document3 && project.document3_required && document3_id.blank?
    out << "#{project.document3_name} document is absent but not required. " if project.show_document3 && document3_id.blank?
    out << "#{project.document4_name} document needs to be uploaded. " if project.show_document4 && project.document4_required && document4_id.blank?
    out << "#{project.document4_name} document is absent but not required. " if project.show_document4 && document4_id.blank?
    out << 'Budget document needs to be uploaded. ' if project.show_budget_form && budget_document_id.blank?
    out << 'PI biosketch needs to be uploaded. ' if project.show_manage_biosketches && applicant_biosketch_document_id.blank?
    out << 'Application document needs to be uploaded. ' if project.show_application_doc && application_document_id.blank?
    out << 'Application has been fully completed!' if out.blank?
    out.compact
  end

  def self.approved_submissions(username)
    self.where('effort_approver_username = :username', { username: username }).all
  end

  def program_name
    project.try(:program).try(:program_name)
  end

  # this will update the applicant's personal biosketch and then add to the submission
  def uploaded_biosketch=(data_field)
    unless data_field.blank?
      self.applicant_biosketch_document = FileDocument.new if applicant_biosketch_document.nil?
      self.applicant_biosketch_document.uploaded_file = data_field
      # do not update the applicant's biosketch
      # self.applicant.uploaded_biosketch = data_field
    end
  end

  # this defines the connection between the model attribute exposed to the form (uploaded_budget)
  # and the file_document model
  def uploaded_budget=(data_field)
    self.budget_document = FileDocument.new if self.budget_document.nil?
    self.budget_document.uploaded_file = data_field unless data_field.blank?
  end

  def uploaded_other_support=(data_field)
    self.other_support_document = FileDocument.new if self.other_support_document.nil?
    self.other_support_document.uploaded_file = data_field unless data_field.blank?
  end

  def uploaded_document1=(data_field)
    self.document1 = FileDocument.new if self.document1.nil?
    self.document1.uploaded_file = data_field unless data_field.blank?
  end

  def uploaded_document2=(data_field)
    self.document2 = FileDocument.new if self.document2.nil?
    self.document2.uploaded_file = data_field unless data_field.blank?
  end

  def uploaded_document3=(data_field)
    self.document3 = FileDocument.new if self.document3.nil?
    self.document3.uploaded_file = data_field unless data_field.blank?
  end

  def uploaded_document4=(data_field)
    self.document4 = FileDocument.new if self.document4.nil?
    self.document4.uploaded_file = data_field unless data_field.blank?
  end

  def uploaded_supplemental_document=(data_field)
    self.supplemental_document = FileDocument.new if self.supplemental_document.nil?
    self.supplemental_document.uploaded_file = data_field unless data_field.blank?
  end

  # this defines the connection between the model attribute exposed to the form (uploaded_application)
  # and the storage fields for the file
  def uploaded_application=(data_field)
    self.application_document = FileDocument.new if self.application_document.nil?
    self.application_document.uploaded_file = data_field unless data_field.blank?
  end

  def clean_params
    # need the before_type_cast or else Rails 2.3 truncates after any comma. strange
    txt = self.direct_project_cost_before_type_cast
    return if txt.blank?
    txt = txt.to_s
    txt = txt.split('.')[0]
    txt = txt.split(',').join
    txt = txt.sub(/\D+(\d*)/, '\1')
    self.direct_project_cost = txt
  end

  def set_defaults
    self.submission_status = PENDING if self.submission_status.blank?
  end

  def save_documents
    do_save(self.budget_document, :budget_document)
    do_save(self.other_support_document, :other_support_document)
    do_save(self.document1, :document1)
    do_save(self.document2, :document2)
    do_save(self.document3, :document3)
    do_save(self.document4, :document4)
    do_save(self.application_document, :application_document)
    set_applicant_biosketch
    do_save(self.applicant_biosketch_document, :applicant_biosketch_document)
    do_save(self.supplemental_document, :supplemental_document)
  end

  def set_applicant_biosketch
    unless self.applicant.blank? || self.applicant.biosketch.blank? # self.applicant.biosketch_document_id.blank?
      if self.applicant_biosketch_document_id.blank?
        # create a new copy of the file associated only with the submission
        unless self.applicant.biosketch.file.blank?
          self.applicant_biosketch_document                   = FileDocument.new(file: self.applicant.biosketch.file)
          self.applicant_biosketch_document.file_content_type = self.applicant.biosketch.file_content_type
          self.applicant_biosketch_document.file_file_name    = self.applicant.biosketch.file_file_name
          self.applicant_biosketch_document.last_updated_at   = self.applicant.biosketch.updated_at
          self.applicant_biosketch_document.save
        end
        begin
          logger.error "saving biosketch: updated_at: #{self.applicant_biosketch_document.last_updated_at} was #{self.applicant.biosketch.updated_at}"
        rescue
          puts 'error logging error when saving biosketch'
        end
        self.save
      end
    end
  end

  def do_save(model, name)
    if !model.nil? && model.changed?
      if model.errors.blank?
        model.save 
      else
        msg = "unable to save #{name.to_s.titleize}: #{model.errors.full_messages.join('; ')}" 
        self.errors.add(name.to_sym, msg)
      end
    end
  end
end
