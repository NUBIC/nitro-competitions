class AddCompletionTextToSubmissionReviews < ActiveRecord::Migration[4.2]
  def change
    add_column :submission_reviews, :completion_text, :text
  end
end
