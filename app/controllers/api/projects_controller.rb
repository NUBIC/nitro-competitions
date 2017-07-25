# # https://robots.thoughtbot.com/better-serialization-less-as-json
# # See above article for possible future changes. 
class Api::ProjectsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index 
    respond_to do |format|
      format.json do
        begin 
          projects = Project.open
          render json: projects.as_json(

          only: [:project_title, :submission_close_date, :membership_required],
          methods: :competition_url,
          include: { program: {only: [:program_name, :program_title] } }) 
        rescue => e
          render json: { errors: e.message}, status: :unprocessable_entity 
        end
      end
    end
  end
end