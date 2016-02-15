class AddScoreToAllReviewsPage < ActiveRecord::Migration
  def change
    add_column :projects, :show_review_scores_to_reviewers, :boolean, default: false
  end
end
