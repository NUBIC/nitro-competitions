class CreateLogs < ActiveRecord::Migration[4.2]
  def self.up
    create_table :logs do |t|
      t.string :activity
      t.integer :user_id
      t.integer :program_id
      t.integer :project_id
      t.string :controller_name
      t.string :action_name
      t.text   :params
      t.string :created_ip

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
