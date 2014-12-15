class ApproversController < ApplicationController
  before_filter  :set_project

  def index
    @sponsor = @project.program
    if has_read_all?(@sponsor) then
      @submissions = @project.submissions.joins(
        'LEFT OUTER JOIN "key_personnel" ON "key_personnel"."submission_id" = "submissions"."id"
         LEFT OUTER JOIN "users" ON "users"."id" = "key_personnel"."user_id"'
      ).all
    else
      @submissions = Submission.approved_submissions(current_user_session.username)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @approvers }
    end
  end

  def update
    submission = Submission.find(params[:id])
    if submission.effort_approver_username == current_user_session.try(:username)
      submission.effort_approval_at = Time.now
      submission.effort_approver_ip = get_client_ip
      submission.save
    end
    redirect_to project_approvers_path(submission.project_id)
    # render :update do |page|
    #   page.replace_html "approval_#{submission.id}", :partial => 'approval', :locals=> {:submission=>submission}
    # end
  end

  private
  def set_project
    unless params[:project_id].blank?
      @project = Project.find(params[:project_id])
      set_current_project(@project)
    end
  end

end
