class AddEmailToSponsor < ActiveRecord::Migration
  def change
    add_column :programs, :email, :string
  end
end
