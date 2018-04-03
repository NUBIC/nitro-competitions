# encoding: UTF-8

class SubmissionReview < ApplicationRecord
  require './lib/competitions/scoring.rb'

  belongs_to  :submission, :counter_cache => true
  has_one     :applicant,  :class_name => 'User', :through => :submission, :source => :applicant # doesn't seem to work
  has_one     :project,    :through => :submission # doesn't seem to work
  belongs_to  :reviewer,   :class_name => 'User', :foreign_key => 'reviewer_id'
  belongs_to  :user,       :foreign_key => 'reviewer_id'

  scope :load_all,      lambda { joins([:applicant]) }
  scope :this_project,  lambda { |*args| joins(:submission).where('submissions.project_id = :project_id', { :project_id => args.first }) }
  scope :active,        lambda { |*args| joins(:submission).where('submissions.project_id IN (:project_ids)', { :project_ids => args.first }) }

  Scoring::CRITERIA.each do |criterion|
    validates_numericality_of "#{criterion}_score".to_sym, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  end

  validates_numericality_of :overall_score, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0

  def project_criteria
    project.review_criteria
  end

  def criteria_scores
    scores = Hash[project_criteria.map { |criterion| [criterion, send("#{criterion}_score").to_i] }]
  end

  def composite_score
    scores = criteria_scores
    return 0 if scores.all?{ |_, score| score.zero? }

    sum_of_scores      = scores.sum  { |_, score| score }
    scored_value_count = scores.count{ |_, score| score > 0 }
    (sum_of_scores.to_f / scored_value_count).round(1)
  end

  def score_sum_and_count
    scores = criteria_scores
    sum_of_scores         = scores.sum { |_, score| score }
    scored_criteria_count = scores.count { |_, score| score.nonzero? }
    [sum_of_scores, scored_criteria_count]
  end

  def incomplete?
    project_criteria.any? { |criterion| send("#{criterion}_score").to_i.zero? }
  end
  alias :has_zero? :incomplete?

  def unscored?
    project_criteria.all? { |criterion| send("#{criterion}_score").to_i.zero? }
  end

end
