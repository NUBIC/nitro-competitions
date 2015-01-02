class AddNotificationColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify_on_new_submission, :boolean, default: true
    add_column :users, :notify_on_complete_submission, :boolean, default: true
  end
end
