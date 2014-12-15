class AddOrdFieldsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :closed_status_wording, :string, default: 'Awarded'
    add_column :projects, :show_review_guidance, :boolean, default: true
  end
end
