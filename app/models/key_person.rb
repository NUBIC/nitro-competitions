# encoding: UTF-8
# == Schema Information
#
# Table name: key_personnel
#
#  id            :integer          not null, primary key
#  submission_id :integer
#  user_id       :integer
#  role          :string(255)
#  username      :string(255)
#  first_name    :string(255)
#  last_name     :string(255)
#  email         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class KeyPerson < ActiveRecord::Base
  # Associations
  belongs_to :submission
  belongs_to :user

  # Accessors
  accepts_nested_attributes_for :submission, :allow_destroy => true, :reject_if => :all_blank
  attr_accessible *column_names
  attr_accessible :user, :submission

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
