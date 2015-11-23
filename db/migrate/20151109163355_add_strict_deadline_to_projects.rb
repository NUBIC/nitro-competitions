class AddStrictDeadlineToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :strict_deadline, :boolean, default: false
  end
end
