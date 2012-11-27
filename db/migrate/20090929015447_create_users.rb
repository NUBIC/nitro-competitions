class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.string :era_commons_name
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :middle_name
      t.string :email
      t.string :degrees
      t.string :name_suffix  #II, Sr, Jr, III, etc
      t.string :business_phone
      t.string :fax
      t.string :title #Professor, Assistant Professor, etc
      t.integer :employee_id
      t.string :primary_department
      t.string :campus
      t.text   :campus_address
      t.text   :address
      t.string :city
      t.string :postal_code
      t.string :state
      t.string :country

      t.string :photo_content_type 
      t.string :photo_file_name 
      t.binary :photo

      t.integer :biosketch_document_id

   		t.timestamp :first_login_at
   		t.timestamp :last_login_at

			t.string    :password_salt
			t.string    :password_hash
			t.timestamp :password_changed_at
			t.integer   :password_changed_id  
			t.string    :password_changed_ip

			t.integer   :created_id  
			t.string    :created_ip
			t.integer   :updated_id  
			t.string    :updated_ip
			t.timestamp :deleted_at
			t.integer   :deleted_id  
			t.string    :deleted_ip

      t.timestamps
    end
    add_index :users, [:username], :unique => true
    # add_index :users, [:era_commons_name], :unique => true
    add_index :users, [:email], :unique => true
    add_index :users, [:era_commons_name]
  end

  def self.down
    drop_table :users
  end
end
