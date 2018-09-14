class AddAllowReviewerNotificationToSponsor < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :allow_reviewer_notification, :boolean, default: true
  end
end