# encoding: UTF-8
class KeyPerson < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  accepts_nested_attributes_for :submission, :allow_destroy => true, :reject_if => :all_blank

  attr_accessible *column_names
  attr_accessible :user, :submission

  def self.quotes
    "\x91\x92\x93\x94".unpack("Z*")
  end
  def self.right_quote
    "\x92".unpack("Z*")[0]
  end

  def uploaded_biosketch=(data_field)
    # this is simply a placeholder for updating the key_person's biosketch.
    self.user.uploaded_biosketch = data_field
  end
  def name
    [first_name, last_name].join(' ').gsub(/\'/, KeyPerson.right_quote).strip
  end
  def sort_name
    [last_name, first_name].join(', ').gsub(/\'/, KeyPerson.right_quote).strip
  end

end
