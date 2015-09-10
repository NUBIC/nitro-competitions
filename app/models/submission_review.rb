# encoding: UTF-8
# == Schema Information
#
# Table name: submission_reviews
#
#  id                              :integer          not null, primary key
#  submission_id                   :integer
#  reviewer_id                     :integer
#  review_score                    :float
#  review_text                     :text
#  review_doc                      :binary
#  review_status                   :string(255)
#  review_completed_at             :datetime
#  innovation_score                :integer          default(0)
#  impact_score                    :integer          default(0)
#  scope_score                     :integer          default(0)
#  team_score                      :integer          default(0)
#  environment_score               :integer          default(0)
#  budget_score                    :integer          default(0)
#  completion_score                :integer          default(0)
#  assigned_at                     :datetime
#  accepted_at                     :datetime
#  assignment_notification_cnt     :integer          default(0)
#  assignment_notification_sent_at :datetime
#  thank_you_sent_at               :datetime
#  assignment_notification_id      :integer
#  thank_you_sent_id               :integer
#  innovation_text                 :text
#  impact_text                     :text
#  scope_text                      :text
#  team_text                       :text
#  environment_text                :text
#  budget_text                     :text
#  overall_score                   :integer          default(0)
#  overall_text                    :text
#  other_score                     :integer          default(0)
#  other_text                      :text
#  created_id                      :integer
#  created_ip                      :string(255)
#  updated_id                      :integer
#  updated_ip                      :string(255)
#  deleted_at                      :datetime
#  deleted_id                      :integer
#  deleted_ip                      :string(255)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

class SubmissionReview < ActiveRecord::Base
  belongs_to :submission, :counter_cache => true
  has_one :applicant,  :class_name => 'User', :through => :submission, :source => :applicant # doesn't seem to work
  has_one :project, :through => :submission # doesn't seem to work
  belongs_to :reviewer, :class_name => 'User', :foreign_key => 'reviewer_id'
  belongs_to :user, :foreign_key => 'reviewer_id'

  scope :load_all, lambda { joins([:applicant]) }
  scope :this_project, lambda { |*args| includes([:submission]).where('submissions.project_id = :project_id', { :project_id => args.first }) }
  scope :active, lambda { |*args| includes([:submission]).where('submissions.project_id IN (:project_ids)', { :project_ids => args.first }) }

  validates_numericality_of :innovation_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :impact_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :scope_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :team_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :environment_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :other_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :budget_score, :allow_nil => true, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0
  validates_numericality_of :overall_score, :only_integer => true, :less_than_or_equal_to => 9, :greater_than_or_equal_to => 0

  def composite_score
    return 0 if count_nonzeros?.blank? || count_nonzeros? < 1
    (((z(innovation_score) + z(impact_score) + z(scope_score) + z(team_score) + z(environment_score) + z(budget_score) + z(other_score)).to_f / count_nonzeros?) * 10).round / 10.0
  end

  def z(val)
    z?(val) ? 0 : val
  end

  def has_zero?
    z?(innovation_score) || z?(impact_score) || z?(scope_score) || z?(team_score) || z?(environment_score)
  end

  def count_nonzeros?
    nz?(innovation_score) + nz?(impact_score) + nz?(scope_score) + nz?(team_score) + nz?(environment_score) + nz?(budget_score) + nz?(other_score)
  end

  def z?(val)
    (val.blank? || val <= 0)
  end

  def nz?(val)
    z?(val) ? 0 : 1
  end
end
