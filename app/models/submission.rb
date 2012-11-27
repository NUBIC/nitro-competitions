class Submission < ActiveRecord::Base
  belongs_to :project
  belongs_to :applicant, :class_name => "User", :foreign_key => "applicant_id"
  belongs_to :submitter, :class_name => "User", :foreign_key => "created_id"
  belongs_to :effort_approver, :class_name => "User", :primary_key => "username", :foreign_key => "effort_approver_username"
  belongs_to :core_manager, :class_name => "User", :primary_key => "username", :foreign_key => "core_manager_username"
  belongs_to :department_administrator, :class_name => "User", :foreign_key => "department_administrator_username", :primary_key => "username"

  belongs_to :applicant_biosketch_document, :class_name => "FileDocument", :foreign_key => 'applicant_biosketch_document_id'
  belongs_to :application_document, :class_name => "FileDocument", :foreign_key => 'application_document_id'
  belongs_to :budget_document, :class_name => "FileDocument", :foreign_key => 'budget_document_id'
  belongs_to :other_support_document, :class_name => "FileDocument", :foreign_key => 'other_support_document_id'
  belongs_to :document1, :class_name => "FileDocument", :foreign_key => 'document1_id'
  belongs_to :document2, :class_name => "FileDocument", :foreign_key => 'document2_id'
  belongs_to :document3, :class_name => "FileDocument", :foreign_key => 'document3_id'
  belongs_to :document4, :class_name => "FileDocument", :foreign_key => 'document4_id'

  has_many :submission_reviews
  has_many :reviewers, :through => :submission_reviews, :source => :user

  has_many :key_personnel, :class_name => "KeyPerson"
  has_many :key_people, :through => :key_personnel, :source => :user

  after_save :save_documents

  accepts_nested_attributes_for :applicant

  default_scope :joins => [:applicant], :order => 'lower(users.last_name), submissions.project_id, lower(submissions.submission_title)'
  named_scope :assigned_submissions, :conditions => ['submission_reviews_count >= 2']
  named_scope :unfilled_submissions, lambda { |*args| {:conditions => [ 'submission_reviews_count < :max_reviewers', {:max_reviewers => args.first || 2 } ] } }

  named_scope :unassigned_submissions, :conditions => {:submission_reviews_count => 0}
  named_scope :recent, lambda { { :conditions => ['submissions.created_at > ?', 3.weeks.ago] } }

  named_scope :user_scoped, lambda { |*args|
    if args.first
      {:include=>[:key_people, :applicant, :project, :submitter, :effort_approver, :department_administrator, :core_manager ]}
    elsif args[2].nil?
      {:conditions => ['applicant_id = :id', {:id => 0} ]}
    else
      {:conditions => ['(applicant_id = :id or created_id = :id) and project_id IN (:projects)', {:projects => args[1], :id => args[2]} ] } 
    end
  }
  
  named_scope :associated, lambda { |*args|
    if args[1].nil?
      {:conditions => ['applicant_id = :id', {:id => 0} ]}
    else
      { :include => 'submission_reviews',
       :conditions => ['(submissions.applicant_id = :id or submissions.created_id = :id) and submissions.project_id IN (:projects)', {:projects => args[0], :id => args[1]} ] } 
    end
  }
    
  named_scope :associated_with_user, lambda { |*args|
    if args.first.nil?
      {:conditions => ['applicant_id = :id', {:id => 0} ]}
    else
      { :include => 'submission_reviews', 
        :conditions => ['submissions.applicant_id = :id or submissions.created_id = :id', {:id => args.first} ], 
        :order => "id asc" } 
    end
  }
  
  attr_accessor :max_budget_request
  attr_accessor :min_budget_request
  
  before_validation :clean_params, :set_defaults
  
  validates_length_of :submission_title, :within => 6..81, :too_long => "--- pick a shorter title", :too_short => "--- pick a longer title"
  validates_numericality_of :direct_project_cost, :greater_than => 1000000, :if => Proc.new { |sub| (sub.direct_project_cost || 0) < sub.min_project_cost && ! sub.direct_project_cost.blank?  }, :message => "is too low"
  validates_numericality_of :direct_project_cost, :less_than => 1000, :if => Proc.new { |sub| (sub.direct_project_cost || 0) > sub.max_project_cost }, :message => "is too high"
  
  def overall_scores 
    return 0 if submission_reviews.length == 0
    cnt = submission_reviews.collect{ |s| s.z?(s.overall_score) ? 0 : 1 }.sum
    return 0 if cnt < 1
    submission_reviews.collect{ |s| s.z?(s.overall_score) ? 0 : s.overall_score }.sum/cnt
  end 
  def overall_scores_string
    return 0 if submission_reviews.length == 0
    overall_scores.to_s + " : " + submission_reviews.collect(&:overall_score).join(" / ")
  end 
  def composite_scores 
    return 0 if submission_reviews.length == 0
    cnt = submission_reviews.collect{ |s| s.has_zero? ? 0 : 1 }.sum
    return 0 if cnt < 1
    submission_reviews.collect{ |s| s.has_zero? ? 0 : s.composite_score }.sum/cnt
  end 
  
  def composite_scores_string
    return 0 if submission_reviews.length == 0
    composite_scores.to_s + " : " + submission_reviews.collect(&:composite_score).join(" / ")
  end 
  
  def max_project_cost 
    max_budget_request || 50000
  end 
  
  def min_project_cost 
    min_budget_request || 1000
  end 

  def status 
    return "Incomplete" if project.blank? or applicant.blank?
    return "Incomplete" if project.show_project_cost and direct_project_cost.blank?
    return "Incomplete" if project.show_effort_approver and effort_approver_username.blank?
    return "Incomplete" if project.show_department_administrator and department_administrator_username.blank?
    return "Incomplete" if project.show_core_manager and core_manager_username.blank?
    return "Incomplete" if project.show_abstract_field and abstract.blank?
    return "Incomplete" if project.show_manage_other_support and other_support_document_id.blank?
    return "Incomplete" if project.show_document1 and document1_id.blank?
    return "Incomplete" if project.show_document2 and document2_id.blank?
    return "Incomplete" if project.show_document3 and document3_id.blank?
    return "Incomplete" if project.show_document4 and document4_id.blank?
    return "Incomplete" if project.show_budget_form and budget_document_id.blank?
    return "Incomplete" if project.show_manage_biosketches and applicant_biosketch_document_id.blank?
    return "Incomplete" if project.show_application_doc and application_document_id.blank?
    "Complete"
  end 
  
  def is_complete?
    self.status == 'Complete'
  end

  def key_personnel_names
    self.key_personnel.map{|k| k.name|| k.user.name}
  end

  def key_personnel_emails
    self.key_personnel.map{|k| k.email|| k.user.email}
  end
 
  def status_reason
    out=[]
    return ["Project undefined"] if project.blank? or applicant.blank?
    out << "Project cost is undefined. Please enter a project cost. " if project.show_project_cost and direct_project_cost.blank?
    out << "#{project.effort_approver_title} unset. Complete in title page. " if project.show_effort_approver and effort_approver_username.blank?
    out << "#{project.department_administrator_title} unset. Complete in title page. "  if project.show_department_administrator and department_administrator_username.blank?
    out << "Core Manager unset. Complete in title page. "  if project.show_core_manager and core_manager_username.blank?
    out << "Abstract needs to be completed. Complete in title page. "   if project.show_abstract_field and abstract.blank?
    out << "Manage Other Support document needs to be uploaded. "  if project.show_manage_other_support and other_support_document_id.blank?
    out << "#{project.document1_name} document needs to be uploaded. "  if project.show_document1 and document1_id.blank?
    out << "#{project.document2_name} document needs to be uploaded. "  if project.show_document2 and document2_id.blank?
    out << "#{project.document3_name} document needs to be uploaded. "  if project.show_document3 and document3_id.blank?
    out << "#{project.document4_name} document needs to be uploaded. "  if project.show_document4 and document4_id.blank?
    out << "Budget document needs to be uploaded. "  if project.show_budget_form and budget_document_id.blank?
    out << "PI biosketch needs to be uploaded. " if project.show_manage_biosketches and applicant_biosketch_document_id.blank?
    out << "Application document needs to be uploaded. "  if project.show_application_doc and application_document_id.blank?
    out << "Application has been fully completed!" if out.blank?
    out.compact
  end 

  def self.approved_submissions(username)
    self.all( :conditions=> ['effort_approver_username = :username',{:username => username} ] )
  end
  def uploaded_biosketch=(data_field)
    # this will update the applicant's personal biosketch and then add to the submission as well
    # set the current biosketch
    unless data_field.blank?
      self.applicant_biosketch_document = FileDocument.new if self.applicant_biosketch_document.nil?
      self.applicant_biosketch_document.uploaded_file = data_field 
      # do not update the applicant's biosketch
      # self.applicant.uploaded_biosketch = data_field 
    end
  end 
 
  # this defines the connection between the model attribute exposed to the form (uploaded_budget ) 
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

  # this defines the connection between the model attribute exposed to the form (uploaded_application ) 
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
    txt = txt.sub(/\D+(\d*)/,'\1')
    self.direct_project_cost=txt
  end
  def set_defaults
    if self.submission_status.blank?
      self.submission_status='Pending'
    end
  end
  
  def save_documents
    do_save(self.budget_document, "budget document")
    do_save(self.other_support_document, "other support document")
    do_save(self.document1)
    do_save(self.document2)
    do_save(self.document3)
    do_save(self.document4)
    do_save(self.application_document, "application document")
    set_applicant_biosketch()
    do_save(self.applicant_biosketch_document, "pi biosketch document")
  end
  
  def set_applicant_biosketch()
    unless self.applicant.blank? or self.applicant.biosketch_document_id.blank?
      if self.applicant_biosketch_document_id.blank?
        # create a new copy of the file associated only with the submission
        self.applicant_biosketch_document = FileDocument.new(:file => self.applicant.biosketch.file)
        self.applicant_biosketch_document.file_content_type = self.applicant.biosketch.file_content_type
        self.applicant_biosketch_document.file_file_name = self.applicant.biosketch.file_file_name
        self.applicant_biosketch_document.last_updated_at = self.applicant.biosketch.updated_at
        self.applicant_biosketch_document.save
        begin
          logger.error "saving biosketch:  updated_at: #{self.applicant_biosketch_document.last_updated_at} was #{self.applicant.biosketch.updated_at}"
        rescue
        end
        self.save
      end
    end
  end
  
  def do_save(model, name="document")
    if !model.nil? and model.changed?
      if model.errors.blank?
        model.save 
      end
      unless model.errors.blank?
        self.errors.add "unable to save #{name}: " + model.errors.full_messages.join("; ")
      end
    end
  end
end
