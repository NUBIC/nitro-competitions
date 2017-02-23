class ChangeProjectUrlToRfaUrl < ActiveRecord::Migration
  def change
    rename_column :projects, :project_url, :rfa_url
  end
end
