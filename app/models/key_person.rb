# encoding: UTF-8

class KeyPerson < ApplicationRecord
  # Associations
  belongs_to :submission
  belongs_to :user

  # Accessors
  accepts_nested_attributes_for :submission, :allow_destroy => true, :reject_if => :all_blank

  # Validations
  validates :role,
            :username,
            :first_name,
            :last_name,
            presence: true

  def uploaded_biosketch=(data_field)
    # this is simply a placeholder for updating the key_person's biosketch.
    self.user.uploaded_biosketch = data_field
  end

  def name
    [first_name.strip, last_name.strip].join(' ')
  end

  def sort_name
    [last_name.strip, first_name.strip].join(', ')
  end
end
