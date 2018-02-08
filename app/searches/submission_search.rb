# encoding: UTF-8
require "searchlight/adapters/action_view"

##
# Searchlight::Search class for Submission object
class SubmissionSearch < Searchlight::Search
  include Searchlight::Adapters::ActionView

  # search_on Submission.order('created_at DESC')

  # searches :submission_status, :project_id

  def base_query
    Submission.all.order('created_at DESC')
  end

  def search_submission_status
    query.where(submission_status: submission_status)
  end

  def search_project_id
    query.joins(:project).where('projects.id = ?', project_id)
  end

end
