class  ExternalUser::RegistrationsController < Devise::RegistrationsController

  protected
    def after_update_path_for(resource)
      edit_project_applicant_path(current_project, current_user)
    end
end