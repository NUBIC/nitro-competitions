class ChangeSystemAdminDefaultInUsers < ActiveRecord::Migration[4.2]
  def up
    change_column_default :users, :system_admin, false
  end
  def down
    change_column_default :users, :system_admin, nil
  end
end