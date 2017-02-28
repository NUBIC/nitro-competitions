class AddCompletionTextToSubmissionReviews < ActiveRecord::Migration
  def change
    add_column :submission_reviews, :completion_text, :text
  end
end
