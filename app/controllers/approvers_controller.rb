class ApproversController < ApplicationController
  before_filter  :set_project
  
  def index
    @sponsor = @project.program
    if has_read_all?(@sponsor) then
      @submissions = @project.submissions.all(:include=>[:key_people,:applicant])
#      @approvers = Submission.all.collect{|e| e.effort_approver }.compact.uniq
    else
#      @approvers = User.find_all_by_id(current_user_session.id)
      @submissions = Submission.approved_submissions(current_user_session.username)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @approvers }
    end
  end
  
  def update
    submission = Submission.find(params[:id])
    if submission.effort_approver_username == current_user_session.username
      submission.effort_approval_at = Time.now
      submission.effort_approver_ip = get_client_ip
      submission.save
    end
    render :update do |page|
      page.replace_html "approval_#{submission.id}", :partial => 'approval', :locals=> {:submission=>submission}
    end
  end

  private
  def set_project
    unless params[:project_id].blank?
      @project = Project.find(params[:project_id])
      set_current_project(@project)
    end
  end

end
