class Projects::DuplicationsController < ApplicationController

  # GET /projects/1/duplications/new
  # GET /projects/1/copy
  def new
    if Project.exists?(params[:id]) && is_admin?(Project.find(params[:id]).program)
      @project = ProjectServices::Duplicate.call(params[:id])
      @program = @project.program
      @project.valid?
      flash.now[:alert] = "You are creating a new project based on #{@project.project_title}"
      respond_to do |format|
        format.html
      end
    elsif Project.exists?(params[:id])
      flash[:alert] = 'Please contact the Sponsor Admin.'
      @program = Project.find(params[:id]).program
      redirect_to(sponsor_path(@program))
    else
      flash[:alert] = 'Project not found. Please contact the Sponsor Admin.'
      redirect_to root_path
    end
  end
end
