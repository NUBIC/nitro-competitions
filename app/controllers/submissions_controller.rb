# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: submissions
#
#  id                                :integer          not null, primary key
#  project_id                        :integer
#  applicant_id                      :integer
#  submission_title                  :string(255)
#  submission_status                 :string(255)
#  is_human_subjects_research        :boolean
#  is_irb_approved                   :boolean
#  irb_study_num                     :string(255)
#  use_nucats_cru                    :boolean
#  nucats_cru_contact_name           :string(255)
#  use_stem_cells                    :boolean
#  use_embryonic_stem_cells          :boolean
#  use_vertebrate_animals            :boolean
#  is_iacuc_approved                 :boolean
#  iacuc_study_num                   :string(255)
#  direct_project_cost               :float
#  is_new                            :boolean
#  use_nmh                           :boolean
#  use_nmff                          :boolean
#  use_va                            :boolean
#  use_ric                           :boolean
#  use_cmh                           :boolean
#  not_new_explanation               :text
#  other_funding_sources             :text
#  is_conflict                       :boolean
#  conflict_explanation              :text
#  effort_approver_ip                :string(255)
#  submission_at                     :datetime
#  completion_at                     :datetime
#  effort_approver_username          :string(255)
#  department_administrator_username :string(255)
#  effort_approval_at                :datetime
#  submission_reviews_count          :integer          default(0)
#  submission_category               :string(255)
#  core_manager_username             :string(255)
#  cost_sharing_amount               :float
#  cost_sharing_organization         :text
#  received_previous_support         :boolean          default(FALSE)
#  previous_support_description      :text
#  committee_review_approval         :boolean          default(FALSE)
#  application_document_id           :integer
#  budget_document_id                :integer
#  abstract                          :text
#  other_support_document_id         :integer
#  document1_id                      :integer
#  document2_id                      :integer
#  document3_id                      :integer
#  document4_id                      :integer
#  applicant_biosketch_document_id   :integer
#  notification_cnt                  :integer          default(0)
#  notification_sent_at              :datetime
#  notification_sent_by_id           :integer
#  notification_sent_to              :string(255)
#  created_id                        :integer
#  created_ip                        :string(255)
#  updated_id                        :integer
#  updated_ip                        :string(255)
#  deleted_at                        :datetime
#  deleted_id                        :integer
#  deleted_ip                        :string(255)
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  supplemental_document_id          :integer
#  total_amount_requested            :float
#  amount_awarded                    :float
#  type_of_equipment                 :string
#


##
# Controller for Submission model.
class SubmissionsController < ApplicationController

  include KeyPersonnelHelper
  require 'submission_emails'

  def index
    # project/:project_id/submissions should be the only way to get here
    projects = Project.where(id: params[:project_id]).all
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

  def show
    @submission = Submission.find(params[:id])
    @submissions = Submission.associated_with_user(current_user_session.id)
    @submission_reviews = @submission.submission_reviews
    if @submission && (has_read_all?(@submission.project.program) ||
                       @submissions.map(&:id).include?(@submission.id) ||
                       @submission_reviews.map(&:reviewer_id).include?(current_user_session.id))
      respond_to do |format|
        format.html
        format.xml  { render xml: @submission }
      end
    else
      redirect_url = @submission.project.blank? ? projects_path : project_submissions_path(@submission.project.id)
      redirect_to redirect_url
    end
  end

  def new
    user_id = params[:applicant_id] || current_user_session.id
    @applicant = User.find(user_id) unless user_id.blank?
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    redirect_url =  @project.blank? ? projects_path : project_path(@project.id)
    if @applicant.blank?
      flash[:alert] = 'Applicant cannot be blank'
      redirect_to redirect_url
    elsif @project.blank?
      flash[:alert] = 'Competition cannot be blank'
      redirect_to redirect_url
    elsif !@project.is_open? && @project.strict_deadline
      flash[:alert] = "Competition closed on #{@project.submission_close_date}."
      redirect_to projects_path
    else
      @submission = Submission.new(applicant_id: @applicant.id, project_id: @project.id)
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render xml: @submission }
      end
    end
  end

  def edit
    @submission = Submission.find(params[:id])
    @project    = @submission.project
    set_current_project(@project)
    @applicant  = @submission.applicant
  end

  def create
    @applicant = User.find(params[:applicant_id])
    @project = Project.find(params[:project_id])
    set_current_project(@project)
    @submission = Submission.new(submission_params)
    redirect_url =  @project.blank? ? projects_path : project_path(@project.id)
    if @applicant.blank? 
      flash[:alert] = 'Applicant cannot be blank'
      redirect_to redirect_url
    elsif @project.blank?
      flash[:alert] = 'Competition cannot be blank'
      redirect_to redirect_url
    elsif @submission.blank?
      flash[:alert] = 'Submission cannot be blank'
      redirect_to redirect_url
    elsif !@project.is_open? && @project.strict_deadline
      flash[:alert] = "Competition closed on #{@project.submission_close_date}"
      redirect_to projects_path
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
          flash[:alert] = nil
          flash[:notice] = "Submission <i>'#{@submission.submission_title}'</i> was successfully created"
          format.html { render action: 'edit_documents' }
          format.xml  { render xml: @submission, status: :created, location: @submission }
        else
          flash[:alert] = "Submission #{@submission.submission_title} could not be created. #{@submission.errors.full_messages.join('; ')}"
          format.html { render action: 'new' }
          format.xml  { render xml: @submission.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def submission_params
    params.require(:submission).permit(
      :submission_status, 
      :submission_title, 
      :core_manager_username, 
      :abstract, 
      :is_human_subjects_research,
      :is_irb_approved,
      :irb_study_num,
      :is_iacuc_approved,
      :iacuc_study_num,
      :use_nucats_cru,
      :nucats_cru_contact_name,
      :use_stem_cells,
      :use_embryonic_stem_cells,
      :use_vertebrate_animals,
      :direct_project_cost,
      :total_amount_requested,
      :amount_awarded,
      :type_of_equipment,
      :cost_sharing_amount,
      :cost_sharing_organization,
      :received_previous_support,
      :previous_support_description,
      :is_new,
      :not_new_explanation,
      :use_nmh,
      :use_nmff,
      :use_ric,
      :use_va,
      :use_cmh,
      :other_funding_sources,
      :is_conflict,
      :conflict_explanation,
      :department_administrator_username,
      :committee_review_approval,
      :effort_approver_username,
      :project_id,
      :uploaded_biosketch,
      :uploaded_application,
      :uploaded_budget,
      :uploaded_other_support,
      :uploaded_document1,
      :uploaded_document2,
      :uploaded_document3,
      :uploaded_document4,
      :uploaded_supplemental_document,
      :submission_status,
      key_personnel: [
        :username,
        :first_name,
        :last_name,
        :email,
        :role,
        :uploaded_biosketch
      ]
    )
  end

  def update
    @submission = Submission.find(params[:id])
    @project = @submission.project
    set_current_project(@project)
    @submission.max_budget_request = @project.max_budget_request || 50_000
    @submission.min_budget_request = @project.min_budget_request || 1000

    before_update(@submission)
    unless params[:submission].blank?
      handle_usernames(@submission)
    end

    respond_to do |format|
      # params[:submission].delete(:id)  # id causes an error  - can't mass assign id
      if @submission.update_attributes(submission_params)
        handle_key_personnel_param(@submission) unless params[:submission].blank?
        flash[:alert] = nil
        send_submission_email(@submission)
        flash[:notice] = "Submission <i>'#{@submission.submission_title}'</i> was successfully updated"
        flash[:notice] = "#{flash[:notice]} and is COMPLETE!!" if @submission.is_complete?
        flash[:alert] = "Submission was saved but: #{@submission.errors.full_messages.join('; ')}" unless @submission.errors.blank?
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
      if !is_admin?(@submission.project.program) && !(current_user_can_edit_submission?(submission) && submission.is_open?)
        flash[:alert] = 'You cannot reassign this proposal.'
        format.html { redirect_to project_path(submission.project_id) }
      elsif params[:applicant_id].blank?
        @users = User.all.order('last_name')
        format.html { render  }
      elsif submission.applicant_id  > 0 && submission.save
        flash[:notice] = "Submission was successfully reassigned to #{applicant.name}."
        format.html { redirect_to project_submissions_path(submission.project_id) }
        format.xml  { head :ok }
      else
        flash[:alert] = "Submission  <i>#{submission.submission_title}</i> could not be reassigned;  #{submission.errors.full_messages.join('; ')}"
        format.html { render action: 'edit' }
        format.xml  { render xml: submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    submission = Submission.find(params[:id])
    project = Project.find(submission.project_id)
    if is_admin?(@submission.project.program) || (current_user_can_edit_submission?(submission) && submission.is_open?)
      flash[:notice] = "Submission <i>#{submission.submission_title}</i> was successfully deleted"
      submission.destroy
    else
      flash[:alert] = "Submission  <i>#{submission.submission_title}</i> could not be deleted"
    end

    respond_to do |format|
      format.html { redirect_to(project_path(project.id)) }
      format.xml  { head :ok }
    end
  end

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
    if should_send_submission_email(submission)
      logger.error('sending email')
      @logged = nil
      log_request('sending finalize email')
      send_finalize_email(submission, current_user_session)
    end
  end

  def should_send_submission_email(submission)
    is_admin? ? (submission.applicant == current_user) : true
  end
end
