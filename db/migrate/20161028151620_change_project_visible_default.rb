class ChangeProjectVisibleDefault < ActiveRecord::Migration
  def change
    change_column_default :projects, :visible, false
  end
end
