class CreateSubmissionReviews < ActiveRecord::Migration[4.2]
  def self.up
    create_table :submission_reviews do |t|
      t.integer :submission_id
      t.integer :reviewer_id
      t.float :review_score
      t.text :review_text
      t.binary :review_doc
      t.string :review_status
      t.timestamp :review_completed_at
      t.integer :innovation_score, :default=>0
      t.integer :impact_score, :default=>0
      t.integer :scope_score, :default=>0
      t.integer :team_score, :default=>0
      t.integer :environment_score, :default=>0
      t.integer :budget_score, :default=>0
      t.integer :completion_score, :default=>0
      t.timestamp :assigned_at
      t.timestamp :accepted_at

      t.integer :assignment_notification_cnt, :default=>0
      t.timestamp :assignment_notification_sent_at
      t.timestamp :thank_you_sent_at
      t.integer :assignment_notification_id
      t.integer :thank_you_sent_id
      t.text :innovation_text
      t.text :impact_text
      t.text :scope_text
      t.text :team_text
      t.text :environment_text
      t.text :budget_text
      t.integer :overall_score, :default=>0
      t.text :overall_text

      t.integer :other_score, :default=>0
      t.text :other_text
 
      t.integer   :created_id  
      t.string    :created_ip
      t.integer   :updated_id  
      t.string    :updated_ip
      t.timestamp :deleted_at
      t.integer   :deleted_id  
      t.string    :deleted_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :submission_reviews
  end
end
