# # https://robots.thoughtbot.com/better-serialization-less-as-json
# # See above article for possible future changes. 
# class Api::ProjectsController < ApplicationController
#   skip_before_filter :authenticate_user!

#   def index 
#     begin 
#       projects = Project.open
#       respond_to do |format|
#         format.json { render json: projects.as_json(
#           only: [:project_title, :submission_close_date, :project_url],
#           include: { program: {only: [:program_name, :program_title] } }) }
#       end
#     rescue => e
#       respond_to do |format|
#         format.json { render json: { errors: e.message}, status: :unprocessable_entity }
#       end

#     end

#   end
# end