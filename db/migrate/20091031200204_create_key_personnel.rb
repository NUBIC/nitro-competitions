class CreateKeyPersonnel < ActiveRecord::Migration
  def self.up
    create_table :key_personnel do |t|
      t.integer :submission_id
      t.integer :user_id
      t.string :role
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :key_personnel
  end
end
