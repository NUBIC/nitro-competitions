class AddScoreToAllReviewsPage < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :show_review_scores_to_reviewers, :boolean, default: false
  end
end
