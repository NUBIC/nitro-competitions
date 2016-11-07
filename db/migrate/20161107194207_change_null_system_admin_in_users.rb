class ChangeNullSystemAdminInUsers < ActiveRecord::Migration
  def change
    change_column_null :users, :system_admin, false
  end
end