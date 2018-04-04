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
    Hash[project_criteria.map { |criterion| [criterion, send("#{criterion}_score").to_i] }]
  end

  def scores
    project_criteria.map { |criterion| send("#{criterion}_score").to_i }
  end

  def composite_score
    review_scores = scores
    return 0 if review_scores.all?(&:zero?)
    (review_scores.sum.to_f / review_scores.count(&:nonzero?)).round(1)
  end

  def incomplete?
    project_criteria.any? { |criterion| send("#{criterion}_score").to_i.zero? }
  end
  alias :has_zero? :incomplete?

  def unscored?
    project_criteria.all? { |criterion| send("#{criterion}_score").to_i.zero? }
  end

end
