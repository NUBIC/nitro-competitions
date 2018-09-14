class AddStrictDeadlineToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :strict_deadline, :boolean, default: false
  end
end
