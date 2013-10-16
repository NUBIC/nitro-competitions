# == Schema Information
# Schema version: 20130511121216
#
# Table name: file_documents
#
#  created_at        :datetime
#  created_id        :integer
#  created_ip        :string(255)
#  file_content_type :string(255)
#  file_file_name    :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  id                :integer          not null, primary key
#  last_updated_at   :datetime
#  updated_at        :datetime
#  updated_id        :integer
#  updated_ip        :string(255)
#

require 'test_helper'

class FileDocumentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
