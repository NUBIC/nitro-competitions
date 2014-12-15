# -*- coding: utf-8 -*-

##
# Controller for Submission model.
class SubmissionsController < ApplicationController

  include KeyPersonnelHelper
  require 'submission_emails'
  # GET /submissions
  # GET /submissions.xml
  def index
    # project/:project_id/submissions should be the only way to get here

    projects = Project.find_all_by_id(params[:project_id])
    @project = projects[0] unless projects.blank?
    @submissions = Submission.associated(projects.map(&:id), current_user_session.id)
    if @submissions.nil?
      render :inline, 'user not found'
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render xml: @submissions }
      end
    end
  end

  def all
    @submissions = Submission.associated_with_user(current_user_session.id)
    @title = 'All your submissions'
    if @submissions.nil?
      render :inline, 'user not found'
    else
      respond_to do |format|
        format.html { render :index }# index.html.erb
        format.xml  { render xml: @submissions }
      end
    end
  end

  # GET /submissions/1
  # GET /submissions/1.xml
  def show
    @submission = Submission.find(params[:id])
    @submissions = Submission.associated_with_user(current_user_session.id)
    @submission_reviews = @submission.submission_reviews
    if @submission && (has_read_all?(@submission.project.program) ||
                       @submissions.map(&:id).include?(@submission.id) ||
                       @submission_reviews.map(&:reviewer_id).include?(current_user_session.id))
      respond_to do |format|
        format.html { render stylesheets: %w(submission pdf), layout: 'pdf' } # show.html.erb
        format.pdf do
          render pdf: @submission.submission_title,
                 stylesheets: %w(submission pdf),
                 layout: 'pdf'
        end
        format.xml  { render xml: @submission }
      end
    else
      redirect_url = @submission.project.blank? ? projects_path : project_submissions_path(@submission.project.id)
      redirect_to redirect_url
    end
  end

  # GET /submissions/new
  # GET /submissions/new.xml
  def new
    user_id = params[:applicant_id] || current_user_session.id
    @applicant = User.find(user_id) unless user_id.blank?
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    if @applicant.blank? || @project.blank?
      redirect_url =  @project.blank? ? projects_path : project_path(@project.id)
      redirect_to redirect_url
    else
      @submission = Submission.new(applicant_id: @applicant.id, project_id: @project.id)
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render xml: @submission }
      end
    end
  end

  # GET /submissions/1/edit
  def edit
    @submission = Submission.find(params[:id])
    @project    = @submission.project
    @applicant  = @submission.applicant
  end

  # POST /submissions
  # POST /submissions.xml
  def create
    @applicant = User.find(params[:applicant_id])
    @project = Project.find(params[:project_id])
    @submission = Submission.new(params[:submission])
    if @applicant.blank? || @project.blank? || @submission.blank?
      redirect_url =  @project.blank? ? projects_path : project_path(@project.id)
      redirect_to redirect_url
    else
      @submission.max_budget_request = @project.max_budget_request || 50_000
      @submission.min_budget_request = @project.min_budget_request || 1000
      @submission.applicant_id = @applicant.id
      handle_usernames(@submission)
      @title = 'Application Process - Step 3 (last step!)'
      before_create(@submission)
      respond_to do |format|
        if @submission.save
          handle_key_personnel_param(@submission) unless params[:submission].blank?
          flash[:errors] = nil
          flash[:notice] = "Submission <i>'#{@submission.submission_title}'</i> was successfully created"
          format.html { render action: 'edit_documents' }
          format.xml  { render xml: @submission, status: :created, location: @submission }
        else
          flash[:errors] = "Submission #{@submission.submission_title} could not be created. #{@submission.errors.full_messages.join('; ')}"
          format.html { render action: 'new' }
          format.xml  { render xml: @submission.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /submissions/1
  # PUT /submissions/1.xml
  def update
    @submission = Submission.find(params[:id])
    @project = Project.find(@submission.project_id)
    @applicant = User.find(@submission.applicant_id)
    @submission.max_budget_request = @project.max_budget_request || 50_000
    @submission.min_budget_request = @project.min_budget_request || 1000
    before_update(@submission)
    unless params[:submission].blank?
      handle_key_personnel_param(@submission)
      handle_usernames(@submission)
    end

    respond_to do |format|
      params[:submission].delete(:id)  # id causes an error  - can't mass assign id
      if @submission.update_attributes(params[:submission])
        flash[:errors] = nil
        send_submission_email(@submission)
        flash[:notice] = "Submission <i>'#{@submission.submission_title}'</i> was successfully updated"
        flash[:notice] = "#{flash[:notice]} and is COMPLETE!!" if @submission.is_complete?
        flash[:errors] = "Submission was saved but: #{@submission.errors.full_messages.join('; ')}" unless @submission.errors.blank?
        format.html { redirect_to project_path(@project.id) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit' }
        format.xml  { render xml: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def reassign_applicant
    submission = Submission.find(params[:id])
    before_update(submission)
    @submission = submission
    unless params[:applicant_id].blank?
      applicant = User.find(params[:applicant_id])
      submission.applicant_id  =  applicant.id
    end
    respond_to do |format|
      if !is_admin? &&
         !((is_current_user?(submission.created_id) || is_current_user?(submission.applicant_id)) &&
         submission.project.submission_open_date < Date.today && submission.project.submission_close_date >= Date.today)
        flash[:errors] = 'You cannot reassign this proposal.'
        format.html { redirect_to project_path(submission.project_id) }
      elsif params[:applicant_id].blank?
        @users = User.all
        format.html { render  }
      elsif submission.applicant_id  > 0 && submission.save
        flash[:notice] = "Submission was successfully reassigned to #{applicant.name}."
        format.html { redirect_to project_submissions_path(submission.project_id) }
        format.xml  { head :ok }
      else
        flash[:errors] = "Submission  <i>#{submission.submission_title}</i> could not be reassigned;  #{submission.errors.full_messages.join('; ')}"
        format.html { render action: 'edit' }
        format.xml  { render xml: submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.xml
  def destroy
    submission = Submission.find(params[:id])
    project = Project.find(submission.project_id)
    if is_admin? || (current_user_created_submission?(submission) && is_live_submission?(submission.project))
      flash[:notice] = "Submission <i>#{submission.submission_title}</i> was successfully deleted"
      submission.destroy
    else
      flash[:errors] = "Submission  <i>#{submission.submission_title}</i> could not be deleted"
    end

    respond_to do |format|
      format.html { redirect_to(project_path(project.id)) }
      format.xml  { head :ok }
    end
  end

  def current_user_created_submission?(submission)
    is_current_user?(submission.created_id) || is_current_user?(submission.applicant_id)
  end

  def is_live_submission?(project)
    project.submission_open_date < Date.today && project.submission_close_date >= Date.today
  end

  # GET /submissions/1/edit_documents
  def edit_documents
    edit
  end

  private

  def handle_usernames(submission)
    make_user(submission.core_manager_username)
    make_user(submission.effort_approver_username)
    make_user(submission.department_administrator_username)
  end

  def send_submission_email(submission)
    logger.error('sending email')
    @logged = nil
    log_request('sending finalize email')
    send_finalize_email(submission, current_user_session)
  end

end
