class Projects::DuplicationsController < ApplicationController

  # GET /projects/1/duplications/new
  def new
    if is_admin?(@program)
      @original_project = Project.find(params[:project_id])
      # duplicate the project
      @project = Project::Duplication.clear_duplication_attributes(@original_project)
      # update attributes
      @project.write_attribute(:visible, false)
      # clear_duplication_attributes
      # set the program
      @program = @project.program

      flash.now[:alert] = "Creating a new project based on #{@project.project_title}"
      respond_to do |format|
        format.html
      end
    else
      redirect_to(project_path(@original_project))
    end
  end
end
