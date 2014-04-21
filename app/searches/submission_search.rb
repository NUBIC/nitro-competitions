# encoding: UTF-8

##
# Searchlight::Search class for Submission object
class SubmissionSearch < Searchlight::Search

  search_on Submission.order('created_at DESC')

  searches :submission_status, :project_id

  def search_submission_status
    search.where(submission_status: submission_status)
  end

  def search_project_id
    search.joins(:project).where('projects.id = ?', project_id)
  end

end
