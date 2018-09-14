class ChangeNullSystemAdminInUsers < ActiveRecord::Migration[4.2]
  def change
    change_column_null :users, :system_admin, false
  end
end