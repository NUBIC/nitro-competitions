# -*- coding: utf-8 -*-
class CreatePersonIdentities < ActiveRecord::Migration
  def change
    create_table :person_identities do |t|
      t.integer :person_id
      t.string :identifier
      t.integer :source_id
      t.string :provider
      t.string :uid
      t.string :email
      t.string :nickname
      t.string :username
      t.string :domain
      t.datetime :deleted_at
      

      t.timestamps
    end
    add_foreign_key :person_identities, :people, :column => 'person_id', :name => "person_id_to_person_identities_fk"
  end
end
