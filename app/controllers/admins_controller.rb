class AdminsController < ApplicationController

  include AdminsHelper
  before_filter  :set_project

  # all admin methods have a :sponsor_id set

  def index
    @sponsor = @project.program
    if has_read_all?(@sponsor)
      @submissions = Submission.includes([:key_personnel, :applicant, :submitter, :reviewers])
                               .where('project_id = :project_id', { :project_id => @project.id })
                               .all

      @applicants      = @submissions.map { |s| s.applicant }.compact.uniq.sort { |a, b| a.sort_name.downcase <=> b.sort_name.downcase }
      @key_personnel   = (@submissions.map { |s| s.key_personnel.map { |k| k } }.flatten).compact.uniq.sort { |a, b| a.sort_name.downcase <=> b.sort_name.downcase }
      @core_managers   = @submissions.map { |t| t.core_manager }.flatten.compact.uniq.sort { |a, b| a.sort_name.downcase <=> b.sort_name.downcase }
      @submitters      = @submissions.map { |s| s.submitter }.compact.uniq.sort { |a, b| a.sort_name.downcase <=> b.sort_name.downcase }
      @approvers       = @submissions.map { |e| e.effort_approver }.compact.uniq.sort { |a, b| a.sort_name.downcase <=> b.sort_name.downcase }
      @business_admins = @submissions.map { |e| e.department_administrator }.compact.uniq.sort { |a, b| a.sort_name.downcase <=> b.sort_name.downcase }
      @reviewers       = @submissions.map { |e| e.reviewers.map { |r| r } }.flatten.compact.uniq.sort { |a, b| a.sort_name.downcase <=> b.sort_name.downcase }
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    else
      redirect_to projects_path
    end
  end

  # Show applicants for all competitions
  def view_applicants
    start_date = Date.today.beginning_of_year
    start_date -= 365 if Date.today - start_date < 90
    @submissions = Submission.includes([:applicant]).where('submissions.created_at > :start', { :start => start_date }).all

    @activity = "all applicants from #{start_date.to_s} to today for all competitions"
    if has_read_all?(@sponsor)
      respond_to do |format|
        format.html { render :view_applicants }
        format.xml  { render :xml => @applicants }
      end
    else
      redirect_to projects_path
    end
  end

  # Show applicants for sponsored competitions
  def view_sponsor_applicants
    sponsor = @project.program
    @submissions = Submission.includes([:applicant])
                             .joins([:project])
                             .where('projects.program_id = :sponsor_id', { :sponsor_id => sponsor.id })
                             .order('submissions.created_at').all

    @activity = "all applicants for all compeitions sponsored by #{sponsor.program_name}"
    if has_read_all?(@sponsor)
      respond_to do |format|
        format.html { render :view_applicants }
        format.xml  { render :xml => @applicants }
      end
    else
      redirect_to projects_path
    end
  end

  def view_activities
    @sponsor = @project.program
    @logs = @sponsor.logs
    @activity = 'all logged'
    render_view_activities
  end

  def view_logins
    @sponsor = @project.program
    @logs = @project.logs.logins
    @activity = 'login'
    render_view_activities
  end

  def view_submissions
    @sponsor = @project.program
    @logs = @project.logs.submissions
    @activity = 'submission'
    render_view_activities
  end

  def view_reviews
    @sponsor = @project.program
    @logs = @project.logs.reviews
    @activity = 'review'
    render_view_activities
  end

  def act_as_user
    @sponsor = @project.program
    if is_super_admin?
      if defined? params[:username].blank?
        @users = User.all
      else
        @current_user_session = User.find_by_username(params[:username])
        session[:username] = @current_user_session.try(:username)
        session[:name] = @current_user_session.try(:name)

        act_as_admin

        redirect_to projects_path
      end
    else
      redirect_to projects_path
    end
  end

  def submissions
    @sponsor = @project.program
    if has_read_all?(@sponsor)
      @submissions = @project.submissions
    else
      redirect_to projects_path
    end
  end

  def submission_search
    @search = SubmissionSearch.new(submission_search_params)
    @submissions = @search.results
    Rails.logger.info("~~~ There are #{@submissions.count} submissions for #{submission_search_params.inspect}")
    respond_to do |format|
      format.html
      format.js
    end
  end

  def submission_search_params
    @search_params ||= params.delete(:submission_search) || {}
  end
  protected :submission_search_params

  def reviews
    @sponsor = @project.program
    if has_read_all?(@sponsor)
      @submissions = @project.submissions
    else
      redirect_to projects_path
    end
  end

  def reviewers
    @sponsor = @project.program
    if has_read_all?(@sponsor)
      prep_reviewer_data
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @reviewers }
      end
    else
      redirect_to projects_path
    end
  end

  def add_reviewers
    @sponsor = @project.program
    if is_admin?(@sponsor)
      flash[:notice] = ''
      reviewers_to_add = params[:admin][:reviewer_list].split(/\s*,\s*|\s+/)
      reviewers_to_add.each do | netid |
        netid = netid.strip
        if make_user(netid)
          the_user = User.find_by_username(netid)
          if the_user.nil? || the_user.id.nil?
            flash[:notice] += "make_user returned true, however could not find netid #{netid}; "
          else
            reviewer = Reviewer.where('(program_id = :program_id and user_id = :user_id)', { :program_id => @sponsor.id, :user_id => the_user.id }).first
            if reviewer.nil? || reviewer.id.nil?
              flash[:notice] += "Added #{netid} (#{the_user.name}) as reviewer; "
              reviewer = Reviewer.new(:program_id => @sponsor.id, :user_id => the_user.id)
              before_create(reviewer)
              reviewer.save
            else
              flash[:notice] += "Reviewer #{netid} (#{the_user.name}) was already assigned; "
            end
          end
        else
          flash[:notice] += "Could not find netid #{netid}; "
        end
      end
      prep_reviewer_data
      render :action => 'reviewers'
    else
      redirect_to projects_path
    end
  end

  def remove_reviewer
    @sponsor = @project.program
    if is_admin?(@sponsor)
      flash[:notice] = ''
      the_reviewer = Reviewer.find(params[:id])
      if the_reviewer.nil? || the_reviewer.id.nil?
        flash[:notice] += "Could not find reviewer #{params[:id]}! "
      else
        the_user = the_reviewer.user
        user_reviews = the_user.submission_reviews.this_project(@project.id)
        flash[:notice] += "Removed reviewer #{the_user.name}"
        if user_reviews.length > 0
          flash[:notice] += "; NOTE: DELETED #{user_reviews.length} reviews"
          user_reviews.each do |sr|
            sr.destroy
          end
        end
        the_reviewer.destroy
      end
      prep_reviewer_data
      render :action => 'reviewers'
    else
      redirect_to projects_path
    end
  end

  def show
  end

  def assign_submission
    @sponsor = @project.program
    if is_admin?(@sponsor)
      @reviewer = User.find(params[:id])
      @submission = Submission.find(params[:submission_id])
      @review = @submission.submission_reviews.find_by_reviewer_id(params[:id])
      @submission.submission_reviews << SubmissionReview.new(:submission_id => params[:submission], :reviewer_id => @reviewer.id) if @review.blank?
    end

    redirect_to project_reviewers_path(@project)
  end

  def unassign_submission
    @sponsor = @project.program
    if is_admin?(@sponsor)
      @review = SubmissionReview.find(params[:submission_review_id])
      unless @review.blank?
        @reviewer = @review.user
        @submission = @review.submission
        # SubmissionReview.delete(params[:submission_review_id])
        @submission.submission_reviews.destroy(@review)
      end
    end

    redirect_to project_reviewers_path(@project)
  end

  private

  def prep_reviewer_data
    @reviewers = @sponsor.reviewers
    @unfilled_submissions = @project.submissions.unfilled_submissions(@project.max_assigned_proposals_per_reviewer)
  end

  def set_project
    if defined?(params)
      unless params[:project_id].blank?
        @project = Project.find(params[:project_id])
        set_current_project(@project)
      end
    end
  end

end
