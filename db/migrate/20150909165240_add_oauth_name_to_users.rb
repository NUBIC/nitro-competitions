class AddOauthNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_name, :string
  end
end
