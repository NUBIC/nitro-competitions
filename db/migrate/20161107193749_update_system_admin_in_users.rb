class UpdateSystemAdminInUsers < ActiveRecord::Migration
  def change
    reversible do |d|
      d.up { User.where(system_admin: nil).update_all(system_admin: false) }
    end
  end
end