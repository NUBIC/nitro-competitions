class AddColumnsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :document1_required, :boolean, default: true
    add_column :projects, :document2_required, :boolean, default: true
    add_column :projects, :document3_required, :boolean, default: true
    add_column :projects, :document4_required, :boolean, default: true
  end
end
