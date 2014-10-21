# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20140908190758
#
# Table name: file_documents
#
#  created_at        :datetime         not null
#  created_id        :integer
#  created_ip        :string(255)
#  file_content_type :string(255)
#  file_file_name    :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  id                :integer          not null, primary key
#  last_updated_at   :datetime
#  updated_at        :datetime         not null
#  updated_id        :integer
#  updated_ip        :string(255)
#

require 'spec_helper'

describe FileDocument do

  it 'can be instantiated' do
    FactoryGirl.build(:file_document).should be_an_instance_of(FileDocument)
  end

  it 'can be saved successfully' do
    FactoryGirl.create(:file_document).should be_persisted
  end
end
