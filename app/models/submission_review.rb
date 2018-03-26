# encoding: UTF-8

class SubmissionReview < ApplicationRecord
  belongs_to :submission, :counter_cache => true
  has_one :applicant,  :class_name => 'User', :through => :submission, :source => :applicant # doesn't seem to work
  has_one :project, :through => :submission # doesn't seem to work
  belongs_to :reviewer, :class_name => 'User', :foreign_key => 'reviewer_id'
  belongs_to :user, :foreign_key => 'reviewer_id'

  scope :load_all, lambda { joins([:applicant]) }
  scope :this_project, lambda { |*args| joins(:submission).where('submissions.project_id = :project_id', { :project_id => args.first }) }
  scope :active, lambda { |*args| joins(:submission).where('submissions.project_id IN (:project_ids)', { :project_ids => args.first }) }

  validates_numericality_of :impact_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :team_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :innovation_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :scope_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :environment_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :budget_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :other_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :completion_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0

  validates_numericality_of :overall_score, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0

  def composite_score
    return 0 if unscored?
    (((z(impact_score) +
       z(team_score) +
       z(innovation_score) +
       z(scope_score) +
       z(environment_score) +
       z(budget_score) +
       z(other_score) +
       z(completion_score)).to_f / count_nonzeros?) * 10).round / 10.0
  end

  def z(val)
    z?(val) ? 0 : val
  end

  def has_zero?
    z?(impact_score) ||
    z?(team_score) ||
    z?(innovation_score) ||
    z?(scope_score) ||
    z?(environment_score)
  end

  def count_nonzeros
    nz?(impact_score) +
    nz?(team_score) +
    nz?(innovation_score) +
    nz?(scope_score) +
    nz?(environment_score) +
    nz?(budget_score) +
    nz?(other_score) +
    nz?(completion_score)
  end
  alias :count_nonzeros? :count_nonzeros

  def unscored?
    count_nonzeros.blank? || count_nonzeros < 1
  end

  def z?(val)
    (val.blank? || val <= 0)
  end

  def nz?(val)
    z?(val) ? 0 : 1
  end
end
