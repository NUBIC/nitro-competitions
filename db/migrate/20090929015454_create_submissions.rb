class CreateSubmissions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :submissions do |t|
      t.integer :project_id
      t.integer :applicant_id
      t.string  :submission_title
      t.string  :submission_status
      t.boolean :is_human_subjects_research
      t.boolean :is_irb_approved
      t.string  :irb_study_num
      t.boolean :use_nucats_cru
      t.string  :nucats_cru_contact_name
      t.boolean :use_stem_cells
      t.boolean :use_embryonic_stem_cells
      t.boolean :use_vertebrate_animals
      t.boolean :is_iacuc_approved
      t.string  :iacuc_study_num
      t.float   :direct_project_cost
      t.boolean :is_new
      t.boolean :use_nmh
      t.boolean :use_nmff
      t.boolean :use_va
      t.boolean :use_ric
      t.boolean :use_cmh
      t.text    :not_new_explanation
      t.text    :other_funding_sources
      t.boolean :is_conflict
      t.text    :conflict_explanation
      t.string  :effort_approver_ip
      t.timestamp :submission_at
      t.timestamp :completion_at
      t.string :effort_approver_username
      t.string :department_administrator_username
      t.timestamp :effort_approval_at
      t.string :effort_approver_ip
      t.integer :submission_reviews_count, :default=>0

      t.string :submission_category
      t.string :core_manager_username
      t.float :cost_sharing_amount
      t.text :cost_sharing_organization
      t.boolean :received_previous_support, :default => false
      t.text :previous_support_description
      t.boolean :committee_review_approval, :default => false
      t.integer :application_document_id
      t.integer :budget_document_id
      t.text :abstract
      t.integer :other_support_document_id
      t.integer :document1_id
      t.integer :document2_id
      t.integer :document3_id
      t.integer :document4_id

      t.integer :applicant_biosketch_document_id
      
      t.integer :notification_cnt,  :default => 0
      t.datetime :notification_sent_at
      t.integer :notification_sent_by_id
      t.string :notification_sent_to

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
    drop_table :submissions
  end
end
