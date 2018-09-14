# encoding: UTF-8
#
# Migration to add support for an optional supplemental document
class AddSupplementalDocumentSupport < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :supplemental_document_name, :string, default: 'Supplemental Document (Optional)'
    add_column :projects, :supplemental_document_description, :string, default: 'Please upload any supplemental information here. (Optional)'
    add_column :submissions, :supplemental_document_id, :integer
  end
end
