class Project < ActiveRecord::Base
  belongs_to :program
  belongs_to :creater, :class_name => "User", :foreign_key => "created_id"
  has_many :submissions
  has_many :logs
  default_scope :order => 'submission_close_date DESC'
  before_validation :clean_params
  
  validates_length_of :project_title, :within => 10..100, :too_long => "--- pick a shorter title", :too_short => "--- pick a longer title"
  validates_length_of :project_name, :within => 2..20, :too_long => "--- pick a shorter name", :too_short => "--- pick a longer name"
  validates_uniqueness_of :project_name  #simplifies the logic a lot if we force the project names to be absolutely unique
  validates_presence_of :initiation_date, :message => "you must have an initiation date!"
  validates_presence_of :submission_open_date, :message => "you must have a submission open date!"
  validates_presence_of :submission_close_date, :message => "you must have a submission close date!"
  validates_presence_of :review_start_date, :message => "you must have a review start date!"
  validates_presence_of :review_end_date, :message => "you must have a review end date!"
  validates_presence_of :project_period_start_date, :message => "you must have a project start date!"
  validates_presence_of :project_period_end_date, :message => "you must have a project end date!"
  
  named_scope :current,   lambda { |*date| {:conditions => ['project_period_start_date >= :date and initiation_date <= :initiation_date', {:date => date.first || 1.day.ago, :initiation_date => 60.days.from_now} ] }}
  named_scope :recent,    lambda { |*date| {:conditions => ['project_period_start_date >= :date and initiation_date <= :date', {:date => date.first || 3.months.ago} ] } }
  named_scope :ongoing_projects, lambda { |*date|  { :conditions => ['project_period_end_date >= :date and project_period_start_date <= :date', {:date => date.first || 1.day.ago} ] } }

  named_scope :active,   lambda { |*date| {:conditions => ['project_period_start_date >= :date and initiation_date <= :initiation_date', {:date => date.first || 3.months.ago, :initiation_date => 60.days.from_now} ] }}

  def current_status
    case Date.today
      when Date.today-300..initiation_date  then "Pre-announcement"
      when initiation_date..submission_open_date  then "New announcement" # + " - opens on "+ submission_open_date.to_s(:justdate)
      when submission_open_date..submission_close_date  then "Open for Applications"
      when submission_close_date..review_start_date  then "Closed for Review"
      when review_start_date..review_end_date  then "Under Review"
      when review_end_date..review_end_date+1000  then "Completed"
    else "Unknown"
    end
  end
  
  
  def count_review_criteria?
    show?(show_impact_score) + show?(show_team_score) + show?(show_innovation_score) + show?(show_scope_score) + show?(show_environment_score) + show?(show_budget_score) + show?(show_completion_score) + show?(show_other_score)
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
    self.project_name=txt
  end
  
end
