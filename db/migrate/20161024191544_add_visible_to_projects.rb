class AddVisibleToProjects < ActiveRecord::Migration
  def up
    # add_column :projects, :visible, :boolean, null: false, default: true
    
    # change_column_default :projects, :visible, default: false
  end

  def up
  add_column :projects, :visible, :boolean, null: false, default: false
  
    # Project.all.each do |project|
    #   project.visible = true
    #   project.save!
    # end
  end

  def down
    remove_column :projects, :visible
  end
end