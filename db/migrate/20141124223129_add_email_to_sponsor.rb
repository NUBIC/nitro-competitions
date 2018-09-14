class AddEmailToSponsor < ActiveRecord::Migration[4.2]
  def change
    add_column :programs, :email, :string
  end
end
