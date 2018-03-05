# -*- coding: utf-8 -*-
# (Mostly) RESTful controller for the Project model
class ProjectsController < ApplicationController
  skip_before_action :check_authorization, raise: false
  before_action :set_project, except: [:index, :create, :new]
  require 'config' # specific configuration methods

  # GET /projects
  # GET /projects.xml
  def index
    begin
      initialize_projects
      respond_to do |format|
        format.html # index.html.erb
        format.xml { render xml: @projects }
      end
    rescue Exception => error
      render inline: "<span style='color:red;'>No project found: #{error.message}</span>"
    end
  end

  def initialize_projects
    unless params[:program_name].blank?
      program = Program.find_by_program_name(params[:program_name])
      @projects = Project.where('program_id = :program_id', program_id: program.id).to_a.flatten.uniq if program
    end
    if @projects.blank? || @projects.length == 0
      if !current_program.blank? && has_read_all?(current_program)
        @projects = (Project.early + Project.preinitiation + Project.open + Project.in_review + Project.recently_awarded + Project.late).flatten.uniq
      else
        @projects = (Project.preinitiation + Project.open + Project.in_review + Project.recently_awarded).flatten.uniq
      end
    end
    @programs = {}
    @projects.each do |pr|
      @programs.keys.include?(pr.program) ? @programs[pr.program] << pr : @programs[pr.program] = [pr]
    end
  end
  private :initialize_projects

  # GET /projects/1
  # GET /projects/1.xml
  def show
    unless params[:project_name].blank? || params[:program_name].blank?
      @program = Program.find_by_program_name(params[:program_name])
      unless @program.blank?
        @projects = Project.where('program_id = :program_id and project_name = :project_name',
                                  { project_name: params[:project_name], program_id: @program.id }).to_a
      end
    else
      @projects = Project.where('id = :id', { id: params[:id] }).to_a
      @program = Program.find(@projects[0].program_id)
    end
    unless @projects.blank?
      # get all the submissions for the current user
      @submissions = Submission.associated(@projects.map(&:id), current_user_session.id)
      
      # set the current project to the first item in the @projects list (see above)
      set_current_project(@projects[0])
      @project = current_project

      # get all the assigned_submission_reviews for the current user
      @assigned_submission_reviews = nil
      submission_reviews = current_user_session.submission_reviews
      @assigned_submission_reviews = submission_reviews.this_project(@project.id) unless submission_reviews.blank?
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml { render xml: @project }
      end
    else
      redirect_to projects_url
    end
  end

  def all_reviews
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render xml: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    if params[:program_id] 
      @program = Program.find(params[:program_id])
      if current_project && current_project.program == @program 
        @project = duplicate_project(current_project)
      else
        @project = Project.new(program: @program)
      end
    else
      project = current_project
      @project = duplicate_project(project)
      @program = @project.program
    end

    respond_to do |format|
      if is_admin?(@program)
        format.html # new.html.erb
        format.xml { render xml: @project }
      else
        format.html { redirect_to projects_path }
        format.xml { render xml: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /projects/1/edit
  def edit
    if params[:program_id] 
      @program = Program.find(params[:program_id])
    else
      project = current_project
      @program = @project.program
    end

    respond_to do |format|
      if is_admin?(@program)
        format.html # new.html.erb
        format.xml { render xml: @project }
      else
        format.html { redirect_to(project_path(@project)) }
        format.xml { render xml: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /projects
  # POST /projects.xml
  def create
    @program = Program.find(params[:program_id])
    @project = Project.new(project_params)
    before_create(@project)
    respond_to do |format|
      if is_admin?(@project.program) && @project.valid?
        @project.save!
        set_current_project(@project)
        flash[:notice] = "Project record for #{@project.project_title} was successfully created"
        format.html { redirect_to(project_path(@project)) }
        format.xml { render xml: @project }
      else
        flash[:alert] = "Project record for #{@project.project_title} could not be created; admin: #{is_admin?(@project.program) ? 'Yes' : 'No'}; #{@project.errors.full_messages.join('; ')}"
        format.html { render action: 'new', program_id: @program.id }
        format.xml { render xml: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    if params[:program_id] 
      @program = Program.find(params[:program_id])
    else
      project = current_project
      @program = project.program
    end
    
    respond_to do |format|
      if is_admin?(@program) && @project.update_attributes(project_params)
        flash[:notice] = "Project record for #{@project.project_title} was successfully updated"
        format.html { redirect_to(project_path(@project)) }
        format.xml  { head :ok }
      else
        admin = is_admin?(@program) ? 'Yes' : 'No'
        flash[:alert] = "Project record for #{@project.project_title} could not be updated; admin: #{admin}; errors: #{@project.errors.full_messages.join('; ')}"
        format.html { render action: :show }
        format.xml { render xml: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def project_params
    params.require(:project).permit(
      :program_id,
      :project_name,
      :project_title,
      :rfa_url,
      :project_url_label,
      :initiation_date,
      :submission_open_date,
      :submission_close_date,
      :strict_deadline,
      :submission_modification_date,
      :review_start_date,
      :review_end_date,
      :project_period_start_date,
      :project_period_end_date,
      :membership_required,
      :closed_status_wording,
      :require_era_commons_name,
      :show_effort_approver,
      :effort_approver_title,
      :show_department_administrator,
      :department_administrator_title,
      :applicant_wording,
      :applicant_abbreviation_wording,
      :title_wording,
      :show_other_funding_sources,
      :other_funding_sources_wording,
      :show_submission_category,
      :category_wording,
      :submission_category_description,
      :show_application_doc,
      :application_doc_name,
      :application_doc_description,
      :application_template_url,
      :application_template_url_label,
      :application_info_url,
      :application_info_url_label,
      :show_budget_form,
      :budget_template_url,
      :budget_template_url_label,
      :budget_info_url,
      :budget_info_url_label,
      :show_project_cost,
      :direct_project_cost_wording,
      :min_budget_request,
      :max_budget_request,
      :show_is_new,
      :is_new_wording,
      :show_manage_biosketches,
      :show_manage_coinvestigators,
      :show_manage_other_support,
      :manage_other_support_text,
      :show_document1,
      :document1_required,
      :document1_name,
      :document1_description,
      :document1_template_url,
      :document1_info_url,
      :show_document2,
      :document2_required,
      :document2_name,
      :document2_description,
      :document2_template_url,
      :document2_info_url,
      :show_document3,
      :document3_required,
      :document3_name,
      :document3_description,
      :document3_template_url,
      :document3_info_url,
      :show_document4,
      :document4_required,
      :document4_name,
      :document4_description,
      :document4_template_url,
      :document4_info_url,
      :supplemental_document_name,
      :supplemental_document_description,
      :show_core_manager,
      :show_cost_sharing_amount,
      :show_cost_sharing_organization,
      :show_received_previous_support,
      :show_previous_support_description,
      :show_committee_review_approval,
      :show_abstract_field,
      :abstract_text,
      :show_human_subjects_research,
      :human_subjects_research_text,
      :show_irb_approved,
      :show_irb_study_num,
      :show_use_stem_cells,
      :show_use_embryonic_stem_cells,
      :show_use_vertebrate_animals,
      :show_iacuc_approved,
      :show_iacuc_study_num,
      :show_not_new_explanation,
      :show_is_conflict,
      :show_conflict_explanation,
      :show_use_nucats_cru,
      :show_nucats_cru_contact_name,
      :show_use_nmh,
      :show_use_nmff,
      :show_use_va,
      :show_use_ric,
      :show_use_cmh,
      :max_assigned_reviewers_per_proposal,
      :max_assigned_proposals_per_reviewer,
      :show_composite_scores_to_applicants,
      :show_composite_scores_to_reviewers,
      :show_review_summaries_to_applicants,
      :show_review_summaries_to_reviewers,
      :show_review_scores_to_reviewers,
      :show_review_guidance,
      :custom_review_guidance,
      :comment_review_only,
      :review_guidance_url,
      :overall_impact_title,
      :overall_impact_description,
      :overall_impact_direction,
      :show_impact_score,
      :impact_title,
      :impact_wording,
      :show_team_score,
      :team_title,
      :team_wording,
      :show_innovation_score,
      :innovation_title,
      :innovation_wording,
      :show_scope_score,
      :scope_title,
      :scope_wording,
      :show_environment_score,
      :environment_title,
      :environment_wording,
      :show_budget_score,
      :budget_title,
      :budget_wording,
      :show_total_amount_requested,
      :total_amount_requested_wording,
      :show_type_of_equipment,
      :type_of_equipment_wording,
      :show_other_score,
      :other_title,
      :other_wording,
      :show_completion_score,
      :completion_title,
      :completion_wording,
      :visible)
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    program = @project.program
    if is_admin?(program)
      flash[:notice] = "Project record for #{@project.project_title} was successfully deleted"
      @project.destroy
    else
      admin = is_admin?(program) ? 'Yes' : 'No'
      flash[:alert] = "Project record for #{@project.project_title} could not be deleted; admin: #{admin};"
    end
    respond_to do |format|
      project = program.projects.first
      project = Project.first if project.blank?
      set_current_project(project)
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  # GET /projects/:id/membership_required.html
  def membership_required
  end

  def set_project
    unless params[:id].blank?
      @project = Project.find(params[:id])
      set_current_project(@project) unless @project.blank?
    end
  end
  private :set_project

  def duplicate_project(project)
    Project.new(program_id: project.program_id,
                project_description: project.project_description,
                rfa_url: project.rfa_url,
                show_application_doc: project.show_application_doc,
                initiation_date: project.initiation_date,
                submission_open_date: project.submission_open_date,
                submission_close_date: project.submission_close_date,
                strict_deadline: project.strict_deadline,
                review_start_date: project.review_start_date,
                review_end_date: project.review_end_date,
                project_period_start_date: project.project_period_start_date,
                project_period_end_date: project.project_period_end_date,
                status: project.status,
                min_budget_request: project.min_budget_request,
                max_budget_request: project.max_budget_request,
                max_assigned_reviewers_per_proposal: project.max_assigned_reviewers_per_proposal,
                max_assigned_proposals_per_reviewer: project.max_assigned_proposals_per_reviewer,
                applicant_wording: project.applicant_wording,
                applicant_abbreviation_wording: project.applicant_abbreviation_wording,
                title_wording: project.title_wording,
                category_wording: project.category_wording,
                submission_category_description: project.submission_category_description,
                effort_approver_title: project.effort_approver_title,
                department_administrator_title: project.department_administrator_title,
                is_new_wording: project.is_new_wording,
                other_funding_sources_wording: project.other_funding_sources_wording,
                show_project_cost: project.show_project_cost,
                direct_project_cost_wording: project.direct_project_cost_wording,
                show_submission_category: project.show_submission_category,
                show_core_manager: project.show_core_manager,
                show_cost_sharing_amount: project.show_cost_sharing_amount,
                show_cost_sharing_organization: project.show_cost_sharing_organization,
                show_received_previous_support: project.show_received_previous_support,
                show_previous_support_description: project.show_previous_support_description,
                show_committee_review_approval: project.show_committee_review_approval,
                show_human_subjects_research: project.show_human_subjects_research,
                show_irb_approved: project.show_irb_approved,
                show_irb_study_num: project.show_irb_study_num,
                show_use_nucats_cru: project.show_use_nucats_cru,
                show_nucats_cru_contact_name: project.show_nucats_cru_contact_name,
                show_use_stem_cells: project.show_use_stem_cells,
                show_use_embryonic_stem_cells: project.show_use_embryonic_stem_cells,
                show_use_vertebrate_animals: project.show_use_vertebrate_animals,
                show_iacuc_approved: project.show_iacuc_approved,
                show_iacuc_study_num: project.show_iacuc_study_num,
                show_is_new: project.show_is_new,
                show_not_new_explanation: project.show_not_new_explanation,
                show_use_nmh: project.show_use_nmh,
                show_use_nmff: project.show_use_nmff,
                show_use_va: project.show_use_va,
                show_use_ric: project.show_use_ric,
                show_use_cmh: project.show_use_cmh,
                show_other_funding_sources: project.show_other_funding_sources,
                show_is_conflict: project.show_is_conflict,
                show_conflict_explanation: project.show_conflict_explanation,
                show_effort_approver: project.show_effort_approver,
                show_department_administrator: project.show_department_administrator,
                show_budget_form: project.show_budget_form,
                show_manage_coinvestigators: project.show_manage_coinvestigators,
                show_manage_biosketches: project.show_manage_biosketches,
                require_era_commons_name: project.require_era_commons_name,
                review_guidance_url: project.review_guidance_url,
                overall_impact_title: project.overall_impact_title,
                overall_impact_description: project.overall_impact_description,
                overall_impact_direction: project.overall_impact_direction,
                show_impact_score: project.show_impact_score,
                show_team_score: project.show_team_score,
                show_innovation_score: project.show_innovation_score,
                show_scope_score: project.show_scope_score,
                show_environment_score: project.show_environment_score,
                show_budget_score: project.show_budget_score,
                show_completion_score: project.show_completion_score,
                show_other_score: project.show_other_score,
                impact_title: project.impact_title,
                impact_wording: project.impact_wording,
                team_title: project.team_title,
                team_wording: project.team_wording,
                innovation_title: project.innovation_title,
                innovation_wording: project.innovation_wording,
                scope_title: project.scope_title,
                scope_wording: project.scope_wording,
                environment_title: project.environment_title,
                environment_wording: project.environment_wording,
                other_title: project.other_title,
                other_wording: project.other_wording,
                budget_title: project.budget_title,
                budget_wording: project.budget_wording,
                completion_title: project.completion_title,
                completion_wording: project.completion_wording,
                submission_modification_date: project.submission_modification_date,
                show_abstract_field: project.show_abstract_field,
                abstract_text: project.abstract_text,
                show_manage_other_support: project.show_manage_other_support,
                manage_other_support_text: project.manage_other_support_text,
                show_document1: project.show_document1,
                document1_required: project.document1_required,
                document1_name: project.document1_name,
                document1_description: project.document1_description,
                show_document2: project.show_document2,
                document2_required: project.document2_required,
                document2_name: project.document2_name,
                document2_description: project.document2_description,
                show_document3: project.show_document3,
                document3_required: project.document3_required,
                document3_name: project.document3_name,
                document3_description: project.document3_description,
                show_document4: project.show_document4,
                document4_required: project.document4_required,
                document4_name: project.document4_name,
                document4_description: project.document4_description,
                show_composite_scores_to_applicants: project.show_composite_scores_to_applicants,
                show_composite_scores_to_reviewers: project.show_composite_scores_to_reviewers,
                show_review_summaries_to_applicants: project.show_review_summaries_to_applicants,
                show_review_summaries_to_reviewers: project.show_review_summaries_to_reviewers)
  end
  private :duplicate_project

end
