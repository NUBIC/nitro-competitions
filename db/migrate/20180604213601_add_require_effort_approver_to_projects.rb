class AddRequireEffortApproverToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :require_effort_approver, :boolean, default: false
  end
end
