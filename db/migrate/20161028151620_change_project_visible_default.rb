class ChangeProjectVisibleDefault < ActiveRecord::Migration[4.2]
  def change
    change_column_default :projects, :visible, false
  end
end
