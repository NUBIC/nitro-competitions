class ChangeProjectUrlToRfaUrl < ActiveRecord::Migration[4.2]
  def change
    rename_column :projects, :project_url, :rfa_url
  end
end
