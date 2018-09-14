class AddEmailFlagReceiveSubmissionNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :should_receive_submission_notifications, :boolean, default: true
  end
end
