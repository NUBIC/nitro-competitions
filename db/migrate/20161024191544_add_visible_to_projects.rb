class AddVisibleToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :visible, :boolean, null: false, default: true
  end
end