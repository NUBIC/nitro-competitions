# -*- coding: utf-8 -*-
class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :degrees
      t.string :suffix
      t.hstore :details
      t.string :authentication_token
      t.string :state
      t.string :email
      t.datetime :deleted_at
      t.datetime :remember_created_at
      t.string :remember_token
      t.string :uuid
      t.boolean :admin, :default => false

      t.timestamps
    end
    add_index  :people, :authentication_token, :unique => true
    add_column :people, :properties, :hstore
  end
end