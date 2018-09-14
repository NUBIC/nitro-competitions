class AddOauthNameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :oauth_name, :string
  end
end
