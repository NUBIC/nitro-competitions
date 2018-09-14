class AddReviewFieldsToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :comment_review_only, :boolean, default: false
    add_column :projects, :custom_review_guidance, :text
  end
end
