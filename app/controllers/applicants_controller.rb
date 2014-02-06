# -*- coding: utf-8 -*-

##
# (Mostly) RESTful controller for the Applicant model
class ApplicantsController < ApplicationController
  helper :applicants
  include ApplicationHelper

  before_filter :set_project

  # GET /applicants
  # GET /applicants.xml
  def index
    @sponsor = @project.program
    if has_read_all?(@sponsor)
      @applicants = User.project_applicants(current_project.id)

      respond_to do |format|
        format.html # index.html.erb
        format.xml { render xml: @applicants }
      end
    else
      redirect_to projects_path
    end
  end

  # GET /applicants/1
  # GET /applicants/1.xml
  def show
    @applicant = User.find(params[:id])
    @sponsor = @project.program
    if is_admin?(@sponsor) || @applicant == current_user
      respond_to do |format|
        format.html # show.html.erb
        format.xml { render xml: @applicant }
      end
    else
      redirect_to project_path(current_project.id)
    end
  end

  # GET /applicants/new
  # GET /applicants/new.xml
  def new
    if username_blank?
      redirect_to(applicants_path)
    else
      @applicant = User.find_by_username(determine_username)
      if @applicant.blank?
        @applicant = User.new(username: determine_username)
        @applicant = handle_ldap(@applicant)
      end

      respond_to do |format|
        format.html # new.html.erb
        format.xml { render xml: @applicant }
      end
    end
  end

  def username_blank?
    params[:username].blank? && current_user_session.try(:username).blank? && current_user.try(:username).blank?
  end
  private :username_blank?

  def determine_username
    params[:username] || current_user_session.username || current_user.username
  end
  private :determine_username

  # GET /applicants/1/edit
  def edit
    @applicant = User.find(params[:id])
    @sponsor = @project.program
    if is_admin?(@sponsor) || @applicant == current_user
      respond_to do |format|
        format.html # edit.html.erb
        format.xml { render xml: @applicant }
      end
    else
      redirect_to project_path(current_project.id)
    end
  end

  # POST /applicants
  # POST /applicants.xml
  def create
    if !params[:id].blank?
      @applicant = User.find(params[:id])
    elsif !params[:applicant].blank? && !params[:applicant][:username].blank?
      @applicant = User.find_by_username(params[:applicant][:username])
    end

    @applicant = User.new(params[:applicant]) if @applicant.blank?

    if request.post? || request.put?
      update_applicant
    else
      new
    end
  end

  def update_applicant
    @applicant.validate_for_applicant = true
    @applicant.validate_era_commons_name = false
    @applicant.validate_era_commons_name = current_project.require_era_commons_name unless current_project.blank?
    @applicant.new_record? ? handle_new_applicant_update : handle_existing_applicant_update
  end
  private :update_applicant

  def handle_new_applicant_update
    before_create(@applicant)
    respond_to do |format|
      if @applicant.save
        set_user_session(@applicant)
        flash[:notice] = "Record for #{@applicant.name} was successfully created"
        format.html { redirect_to new_project_applicant_submission_path(params[:project_id], @applicant.id) }
        format.xml { render xml: @applicant, status: :created, location: @applicant }
      else
        flash[:errors] = "Record for #{@applicant.name} could not be created"
        format.html { render action: 'new' }
        format.xml  { render xml: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end
  private :handle_new_applicant_update

  def handle_existing_applicant_update
    before_update(@applicant)
    respond_to do |format|
      if @applicant.update_attributes(params[:applicant])
        set_user_session(@applicant)
        flash[:notice] = "Record for #{@applicant.name} was successfully updated"
        if params[:project_id].blank?
          redirect_path = current_project.blank? ? projects_path : project_path(current_project.id)
        else
          redirect_path = new_project_applicant_submission_path(params[:project_id], @applicant.id)
        end
        format.html { redirect_to(redirect_path) }
        format.xml  { head :ok }
      else
        flash[:errors] = "Record for #{@applicant.name} could not be updated"
        format.html { render action: 'edit' }
        format.xml  { render xml: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end
  private :handle_existing_applicant_update

  # PUT /applicants/1
  # PUT /applicants/1.xml
  def update
    create
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.xml
  def destroy
    @applicant = User.find(params[:id])
    @applicant.destroy if is_admin?

    respond_to do |format|
      format.html { redirect_to(applicants_path) }
      format.xml  { head :ok }
    end
  end

  def username_lookup
    raise StandardError, 'unset' if params[:username].blank?
    @applicant = User.new(username: params[:username])
    begin
      @applicant = handle_ldap(@applicant)
      fail StandardError, "<i>#{params[:username]}</i> not found" if @applicant.last_name.blank?
      respond_to do |format|
        format.html { redirect_to(applicants_path) }
        format.js   { render partial: 'user_name', layout: false, locals: { applicant: @applicant } }
        format.xml  { render layout: false }
      end
    rescue StandardError => error
      render inline: "<span style='color:red;'>#{error.message}</span>"
    rescue Exception => error
      render inline: "<span style='color:red;'>#{error.message}</span>"
    end
  end

  def update_todo_completed_date(newval)
    @user = User.find(params[:id])
    @todo = @user.todos.find(params[:todo])
    @todo.completed = newval
    @todo.save!
    @completed_todos = @user.completed_todos
    @pending_todos = @user.pending_todos
    render :update do |page|
      page.replace_html 'pending_todos', partial: 'pending_todos'
      page.replace_html 'completed_todos', partial: 'completed_todos'
      page.sortable 'pending_todo_list', url: { action: :sort_pending_todos, id: @user }
    end
  end
  private :update_todo_completed_date

  def set_project
    if params[:project_id].blank?
      @project = Project.find(current_project.id)
    else
      @project = Project.find(params[:project_id])
      set_current_project(@project)
    end
  end
  private :set_project

end
