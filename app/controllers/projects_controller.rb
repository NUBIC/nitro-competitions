class ProjectsController < ApplicationController
  skip_before_filter :check_authorization
  before_filter  :set_project, :except => [:index, :create, :new]
  require 'config' #specific config methods
  # GET /projects
  # GET /projects.xml
  def index
    begin
      unless params[:program_name].blank?
        program = Program.find_by_program_name(params[:program_name])
        @projects = Project.all( :conditions=>["program_id = :program_id", {:program_id => program.id}]).flatten.uniq unless program.blank?
      end
      if @projects.blank? or @projects.length == 0
        if !current_program.blank? && has_read_all?(current_program) then
          @projects = Project.all
        else
          @projects = (Project.active).flatten.uniq
        end
      end
      @submissions=Submission.associated_with_user(current_user_session.id) unless current_user_session.blank? or current_user_session.id.blank?
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @projects }
      end
    rescue Exception => error
      render :inline => "<span style='color:red;'>No project found: #{error.message}</span>"
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    unless params[:project_name].blank? or params[:program_name].blank?
      program = Program.find_by_program_name(params[:program_name])
      @projects = Project.all(:conditions=>["program_id = :program_id and project_name = :project_name", {:project_name=>params[:project_name], :program_id => program.id}]) unless program.blank?
    else
      @projects = Project.all(:conditions=>["id = :id", {:id=>params[:id]}])
      program = Program.find_by_id(@projects[0].program_id)
    end
    unless @projects.blank?
      @submissions = Submission.associated(@projects.collect(&:id), current_user_session.id)
      set_current_project(@projects[0])
      @project = current_project()
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @project }
      end
    else
      redirect_to(projects_url)
    end
  end

  def all_reviews
    @project = Project.find_by_id(params[:id])
    respond_to do |format|
      format.html { render :layout=>'pdf' }# show.html.erb
      format.pdf do
         render :pdf => "Reviews for " + @project.project_name, 
            :stylesheets => ["pdf"], 
            :layout => "pdf"
      end
      format.xml  { render :xml => @reviews }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    project = current_project
    
    @project = Project.new(:program_id => project.program_id, :project_description => project.project_description, :project_url => project.project_url, :show_application_doc => project.show_application_doc, :initiation_date => project.initiation_date, :submission_open_date => project.submission_open_date, :submission_close_date => project.submission_close_date, :review_start_date => project.review_start_date, :review_end_date => project.review_end_date, :project_period_start_date => project.project_period_start_date, :project_period_end_date => project.project_period_end_date, :status => project.status, :min_budget_request => project.min_budget_request, :max_budget_request => project.max_budget_request, :max_assigned_reviewers_per_proposal => project.max_assigned_reviewers_per_proposal, :max_assigned_proposals_per_reviewer => project.max_assigned_proposals_per_reviewer, :applicant_wording => project.applicant_wording, :applicant_abbreviation_wording => project.applicant_abbreviation_wording, :title_wording => project.title_wording, :category_wording => project.category_wording, :submission_category_description => project.submission_category_description, :effort_approver_title => project.effort_approver_title, :department_administrator_title => project.department_administrator_title, :is_new_wording => project.is_new_wording, :other_funding_sources_wording => project.other_funding_sources_wording, :show_project_cost => project.show_project_cost, :direct_project_cost_wording => project.direct_project_cost_wording, :show_submission_category => project.show_submission_category, :show_core_manager => project.show_core_manager, :show_cost_sharing_amount => project.show_cost_sharing_amount, :show_cost_sharing_organization => project.show_cost_sharing_organization, :show_received_previous_support => project.show_received_previous_support, :show_previous_support_description => project.show_previous_support_description, :show_committee_review_approval => project.show_committee_review_approval, :show_human_subjects_research => project.show_human_subjects_research, :show_irb_approved => project.show_irb_approved, :show_irb_study_num => project.show_irb_study_num, :show_use_nucats_cru => project.show_use_nucats_cru, :show_nucats_cru_contact_name => project.show_nucats_cru_contact_name, :show_use_stem_cells => project.show_use_stem_cells, :show_use_embryonic_stem_cells => project.show_use_embryonic_stem_cells, :show_use_vertebrate_animals => project.show_use_vertebrate_animals, :show_iacuc_approved => project.show_iacuc_approved, :show_iacuc_study_num => project.show_iacuc_study_num, :show_is_new => project.show_is_new, :show_not_new_explanation => project.show_not_new_explanation, :show_use_nmh => project.show_use_nmh, :show_use_nmff => project.show_use_nmff, :show_use_va => project.show_use_va, :show_use_ric => project.show_use_ric, :show_use_cmh => project.show_use_cmh, :show_other_funding_sources => project.show_other_funding_sources, :show_is_conflict => project.show_is_conflict, :show_conflict_explanation => project.show_conflict_explanation, :show_effort_approver => project.show_effort_approver, :show_department_administrator => project.show_department_administrator, :show_budget_form => project.show_budget_form, :show_manage_coinvestigators => project.show_manage_coinvestigators, :show_manage_biosketches => project.show_manage_biosketches, :require_era_commons_name => project.require_era_commons_name, :review_guidance_url => project.review_guidance_url, :overall_impact_title => project.overall_impact_title, :overall_impact_description => project.overall_impact_description, :overall_impact_direction => project.overall_impact_direction, :show_impact_score => project.show_impact_score, :show_team_score => project.show_team_score, :show_innovation_score => project.show_innovation_score, :show_scope_score => project.show_scope_score, :show_environment_score => project.show_environment_score, :show_budget_score => project.show_budget_score, :show_completion_score => project.show_completion_score, :show_other_score => project.show_other_score, :impact_title => project.impact_title, :impact_wording => project.impact_wording, :team_title => project.team_title, :team_wording => project.team_wording, :innovation_title => project.innovation_title, :innovation_wording => project.innovation_wording, :scope_title => project.scope_title, :scope_wording => project.scope_wording, :environment_title => project.environment_title, :environment_wording => project.environment_wording, :other_title => project.other_title, :other_wording => project.other_wording, :budget_title => project.budget_title, :budget_wording => project.budget_wording, :completion_title => project.completion_title, :completion_wording => project.completion_wording, :submission_modification_date => project.submission_modification_date, :show_abstract_field => project.show_abstract_field, :abstract_text => project.abstract_text, :show_manage_other_support => project.show_manage_other_support, :manage_other_support_text => project.manage_other_support_text, :show_document1 => project.show_document1, :document1_name => project.document1_name, :document1_description => project.document1_description, :show_document2 => project.show_document2, :document2_name => project.document2_name, :document2_description => project.document2_description, :show_document3 => project.show_document3, :document3_name => project.document3_name, :document3_description => project.document3_description, :show_document4 => project.show_document4, :document4_name => project.document4_name, :document4_description => project.document4_description, :show_composite_scores_to_applicants => project.show_composite_scores_to_applicants, :show_composite_scores_to_reviewers  => project.show_composite_scores_to_reviewers, :show_review_summaries_to_applicants  => project.show_review_summaries_to_applicants, :show_review_summaries_to_reviewers  => project.show_review_summaries_to_reviewers )

    respond_to do |format|
      if is_admin? 
        format.html # new.html.erb
        format.xml  { render :xml => @project }
      else
        format.html { redirect_to(projects_path) }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /projects/1/edit
  def edit
    respond_to do |format|
      if is_admin? 
        format.html # new.html.erb
        format.xml  { render :xml => @project }
      else
        format.html { redirect_to(project_path(@project)) }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    before_create(@project)
    respond_to do |format|
      if is_admin? and  @project.save
        set_current_project(@project)
        flash[:notice] = "Project record for #{@project.project_title} was successfully created"
        format.html { redirect_to(project_path(@project)) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        flash[:errors] = "Project record for #{@project.project_title} could not be created; admin: #{is_admin? ? 'Yes' : 'No'}; #{@project.errors.full_messages.join('; ')}"
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    respond_to do |format|
      if is_admin?(@project.program) and  @project.update_attributes(params[:project])
        flash[:notice] = "Project record for #{@project.project_title} was successfully updated"
        format.html { redirect_to(project_path(@project)) }
        format.xml  { head :ok }
      else
        flash[:errors] = "Project record for #{@project.project_title} could not be updated; admin: #{is_admin? ? 'Yes' : 'No'}; errors: #{@project.errors.full_messages.join('; ')}"
        format.html { render :action => :show }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    if is_admin?(@project.program)
      flash[:notice] = "Project record for #{@project.project_title} was successfully deleted"
      @project.destroy 
    else
      flash[:errors] = "Project record for #{@project.project_title} could not be deleted; admin: #{is_admin? ? 'Yes' : 'No'};"
    end
    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def set_project
    unless params[:id].blank?
      @project = Project.find_by_id(params[:id])
      set_current_project(@project) unless @project.blank?
    end
  end
end
