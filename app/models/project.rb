# encoding: UTF-8

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

  def full_competition_url
    NucatsAssist.root_url + show_competition_path(self.program.program_name, self.project_name)
  end

  def set_defaults
    self.rfa_url ||= NucatsAssist.root_url + project_path(self)
  end

end
