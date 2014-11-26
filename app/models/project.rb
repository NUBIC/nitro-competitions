# encoding: UTF-8
class Project < ActiveRecord::Base
  belongs_to :program
  belongs_to :creater, :class_name => "User", :foreign_key => "created_id"
  has_many :submissions
  has_many :submission_reviews, :through => :submissions
  has_many :logs
  default_scope :order => 'submission_open_date DESC'
  before_validation :clean_params

  attr_accessible *column_names
  attr_accessible :creater, :program

  validates_length_of :project_title, :within => 10..100, :too_long => "--- pick a shorter title", :too_short => "--- pick a longer title"
  validates_length_of :project_name, :within => 2..25, :too_long => "--- pick a shorter name", :too_short => "--- pick a longer name"
  validates_uniqueness_of :project_name  #simplifies the logic a lot if we force the project names to be absolutely unique
  validates_presence_of :initiation_date, :message => "you must have an initiation date!"
  validates_presence_of :submission_open_date, :message => "you must have a submission open date!"
  validates_presence_of :submission_close_date, :message => "you must have a submission close date!"
  validates_presence_of :review_start_date, :message => "you must have a review start date!"
  validates_presence_of :review_end_date, :message => "you must have a review end date!"
  validates_presence_of :project_period_start_date, :message => "you must have a project start date!"
  validates_presence_of :project_period_end_date, :message => "you must have a project end date!"

  scope :current, lambda { |*date| where('project_period_start_date >= :date and initiation_date <= :initiation_date', { :date => date.first || 1.day.ago, :initiation_date => 60.days.from_now }) }
  scope :recent, lambda { |*date| where('project_period_start_date >= :date and initiation_date <= :date', { :date => date.first || 3.months.ago }) }
  scope :ongoing_projects, lambda { |*date| where('project_period_end_date >= :date and project_period_start_date <= :date', { :date => date.first || 1.day.ago }) }
  scope :active, lambda { |*date| where('project_period_start_date > :date or review_end_date > :review_end_date', { :date => date.first || 3.months.ago, :review_end_date => 60.days.ago }) }
  scope :early, lambda { where('projects.initiation_date >= :early', { :early => 30.days.from_now }) }
  scope :preinitiation, lambda { where(':now between projects.initiation_date - 30 and projects.submission_open_date', { :now => 1.hour.ago }) }
  scope :open, lambda { where(':now between projects.submission_open_date and projects.submission_close_date', { :now => 1.hour.ago }) }
  scope :in_review, lambda { where(':now between projects.submission_close_date and projects.review_end_date', { :now => 1.hour.ago }) }
  scope :recently_awarded, lambda { where('projects.review_end_date between :then and :now', { :now => 1.hour.ago, :then => 80.days.ago }) }

  scope :late, lambda { where('projects.review_end_date <= :then', { :then => 80.days.ago }) }

  def current_status
    way_before_today = Date.today - 300
    in_the_future = review_end_date + 1000
    case Date.today
    when way_before_today..initiation_date
      pre_initiation_date_status
    when initiation_date..submission_open_date
      pre_submission_date_status
    when submission_open_date..submission_close_date
      open_submission_status
    when submission_close_date..review_start_date
      closed_submission_status
    when review_start_date..review_end_date
      under_review_status
    when review_end_date..in_the_future
      closed_status
    else
      'Unknown'
    end
  end

  ##
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

end
