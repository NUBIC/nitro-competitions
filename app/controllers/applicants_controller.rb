# -*- coding: utf-8 -*-

class ApplicantsController < ApplicationController
  helper :applicants

  before_filter :set_project
  include ApplicationHelper

  def index
    @sponsor = @project.program
    if has_read_all?(@sponsor)
      @applicants = User.project_applicants(current_project.id).uniq

      respond_to do |format|
        format.html # index.html.erb
        format.xml { render xml: @applicants }
      end
    else
      redirect_to projects_path
    end
  end

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

  def new
    if username_blank?
      redirect_to(applicants_path)
    else
      username = determine_username
      @applicant = User.find_by_username(username)
      if @applicant.blank?
        @applicant = User.new(username: username)
        @applicant = handle_ldap(@applicant)
      end
      if @project.membership_required?
        redirect_to membership_required_project_path(@project) unless is_member?(@applicant)
      else
        respond_to do |format|
          format.html # new.html.erb
          format.xml { render xml: @applicant }
        end
      end
    end
  end

  ##
  # i.e "Is a myNUCATS member?"
  def is_member?(applicant)
    nucats_members = query_nucats_membership(name: applicant.username)
    nucats_members = query_nucats_membership(name: applicant.email) if nucats_members.blank? && !applicant.email.blank?
    return nucats_members.first['active'] == 'True' if nucats_members.count == 1
    false
  end

  def get_connection
    Faraday.new(url: ENV['MEMBERSHIP_URL']) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def query_nucats_membership(*criteria)
    connection = get_connection
    response = connection.get do |req|
      req.url ENV['MEMBERSHIP_API_PATH'], criteria.first
    end
    response.success? ? JSON.parse(response.body) : []
  end

  def username_blank?
    params[:username].blank? && current_user_session.try(:username).blank? && current_user.try(:username).blank?
  end
  private :username_blank?

  def determine_username
    params[:username] || current_user_session.try(:username) || current_user.try(:username)
  end
  private :determine_username

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

  def create
    if !params[:id].blank?
      @applicant = User.find(params[:id])
    elsif !params[:applicant].blank? && !params[:applicant][:username].blank?
      @applicant = User.find_by_username(params[:applicant][:username])
    end

    @applicant = User.new(applicant_params) if @applicant.blank?

    respond_to do |format|
      if @applicant.save
        set_user_session(@applicant)
        format.html { redirect_to new_project_applicant_submission_path(params[:project_id], @applicant.id) }
        format.xml { render xml: @applicant, status: :created, location: @applicant }
      else
        format.html { render action: 'new' }
        format.xml  { render xml: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @applicant = User.find(params[:id])

    @applicant.validate_era_commons_name = false
    @applicant.validate_era_commons_name = current_project.require_era_commons_name unless current_project.blank?

    respond_to do |format|
      if @applicant.update_attributes(applicant_params)
        set_user_session(@applicant)
        flash[:notice] = "Profile updated"
        if params[:project_id].blank?
          redirect_path = current_project.blank? ? projects_path : project_path(current_project.id)
        else
          redirect_path = new_project_applicant_submission_path(params[:project_id], @applicant.id)
        end
        format.html { redirect_to(edit_applicant_path(@applicant)) }
        format.xml  { head :ok }
      else
        flash[:alert] = "Profile update failed. Please see error messages."
        format.html { render action: 'edit' }
        format.xml  { render xml: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  def applicant_params
    params.require(:applicant).permit(
      :email,
      :business_phone,
      :title,
      :first_name,
      :last_name,
      :campus,
      :campus_address,
      :address,
      :city,
      :state,
      :postal_code,
      :country,
      :era_commons_name,
      :degrees,
      :primary_department,
      :uploaded_biosketch)
  end

  def destroy
    @applicant = User.find(params[:id])
    @applicant.destroy if is_admin?

    respond_to do |format|
      format.html { redirect_to(applicants_path) }
      format.xml  { head :ok }
    end
  end

  def username_lookup
    lookup_result = ''

    unless params[:username].blank?
      username = params[:username]
      @applicant = User.new(username: username)
      begin
        @applicant = handle_ldap(@applicant)
        lookup_result = @applicant.last_name.blank? ? "#{username} not found" : @applicant.name
      rescue Exception => error
        lookup_result = error.message
      end
    end

    respond_to do |format|
      format.html { redirect_to(applicants_path) }
      format.json { render partial: 'user_name', layout: false, locals: { lookup_result: lookup_result } }
      format.xml  { render layout: false }
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
      id = current_project.blank? ? Project.last.id : current_project.id
      @project = Project.find(id)
    else
      @project = Project.find(params[:project_id])
      set_current_project(@project)
    end
  end
  private :set_project
end
