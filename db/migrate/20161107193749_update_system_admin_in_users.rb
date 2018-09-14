class UpdateSystemAdminInUsers < ActiveRecord::Migration[4.2]
  def change
    reversible do |d|
      d.up { User.where(system_admin: nil).update_all(system_admin: false) }
    end
  end
end