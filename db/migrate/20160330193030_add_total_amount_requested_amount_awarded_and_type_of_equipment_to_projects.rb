class AddTotalAmountRequestedAmountAwardedAndTypeOfEquipmentToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :show_total_amount_requested, :boolean, default: false
    add_column :projects, :total_amount_requested_wording, :string, default: 'Total Amount Requested'
    add_column :submissions, :total_amount_requested, :float
    add_column :submissions, :amount_awarded, :float
    add_column :projects, :show_type_of_equipment, :boolean, default: false
    add_column :projects, :type_of_equipment_wording, :string, default: 'Type of Equipment'
    add_column :submissions, :type_of_equipment, :string
  end
end
