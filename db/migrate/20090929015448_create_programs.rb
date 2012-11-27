class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.string :program_name
      t.string :program_title
      t.string :program_url

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
    drop_table :programs
  end
end
