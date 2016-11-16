class ChangeSystemAdminDefaultInUsers < ActiveRecord::Migration
  def up
    change_column_default :users, :system_admin, false
  end
  def down
    change_column_default :users, :system_admin, nil
  end
end