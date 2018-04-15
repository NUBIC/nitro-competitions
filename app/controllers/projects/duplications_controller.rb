class Projects::DuplicationsController < ApplicationController

  # GET /projects/1/duplications/new
  def new
    @original_project = Project.find(params[:project_id])
    # duplicate the project
    @project = @original_project.dup
    # update attributes
    @project.write_attribute(:visible, false)
    # set the program
    @program = @project.program

    flash.now[:alert] = "Creating a new project based on #{@project.project_title}"
    respond_to do |format|
      format.html
    end
  end
end
