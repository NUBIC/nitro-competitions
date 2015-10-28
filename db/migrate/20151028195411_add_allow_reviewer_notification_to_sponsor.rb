class AddAllowReviewerNotificationToSponsor < ActiveRecord::Migration
  def change
    add_column :programs, :allow_reviewer_notification, :boolean, default: true
  end
end