# encoding: UTF-8
#
# Migration to add membership flag to project (competition)
class AddMembershipRequiredToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :membership_required, :boolean, default: false
  end
end
